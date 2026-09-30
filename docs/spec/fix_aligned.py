"""Idempotent post-align fixes for the Bitbucket spec (keyed on path+method)."""
import json, os
f = os.path.join(os.path.dirname(__file__), 'aligned_ballerina_openapi.json')
d = json.load(open(f))
# 1. spec declares securitySchemes but no top-level security
d['security'] = [{'basic': []}, {'oauth2': []}, {'api_key': []}]
# 2. distinct summaries
S = {
 ('/repositories/{workspace}/{repoSlug}/default-reviewers/{targetUsername}', 'get'): 'Get a repository default reviewer',
 ('/workspaces/{workspace}/projects/{projectKey}/default-reviewers/{selectedUser}', 'get'): 'Get a project default reviewer',
 ('/repositories/{workspace}/{repoSlug}/pullrequests/activity', 'get'): 'List pull request activity log for a repository',
 ('/repositories/{workspace}/{repoSlug}/pullrequests/{pullRequestId}/activity', 'get'): 'List activity log for a pull request',
 ('/teams/{username}/pipelines_config/variables', 'post'): 'Create a variable for a team',
}
for (p, m), s in S.items():
    d['paths'][p][m]['summary'] = s
# 3. inline titles with spaces become invalid `Foo\ Bar` type names
T = {'Rendered Pull Request Markup': 'RenderedPullRequestMarkup', 'Pull Request Commit': 'PullRequestCommit'}
def walk(x):
    if isinstance(x, dict):
        if isinstance(x.get('title'), str) and x['title'] in T: x['title'] = T[x['title']]
        for v in x.values(): walk(v)
    elif isinstance(x, list):
        for v in x: walk(v)
walk(d)

# 4. Every schema property gets a description (the compiler warns "undocumented field"
#    on each generated record field otherwise). Keyed on schema + property; existing
#    descriptions are never touched. A bare $ref property is wrapped as allOf + description.
import re
def words(n):
    n = re.sub(r'([a-z0-9])([A-Z])', r'\1 \2', n).replace('_', ' ').replace('-', ' ').strip().lower()
    return n
def ref_name(x):
    r = x.get('$ref', '') if isinstance(x, dict) else ''
    return r.rsplit('/', 1)[-1] if r else ''
SPECIAL = {
    'type': 'Discriminator that identifies the type of this object.',
    'name': 'Name of the {owner}.',
    'href': 'URL of the linked resource.',
    'links': 'Hypermedia links related to the {owner}.',
    'id': 'Unique numeric identifier of the {owner}.',
    'uuid': 'Universally unique identifier of the {owner}.',
    'user': 'The user associated with the {owner}.',
    'permission': 'The permission level granted on the {owner}.',
    'size': 'Total number of items in the collection, when known.',
    'page': 'Current page number.',
    'pagelen': 'Number of items per page.',
    'next': 'URL of the next page of results, if any.',
    'previous': 'URL of the previous page of results, if any.',
}
def describe(owner, prop, sch):
    o = words(owner)
    if prop == 'values':
        it = sch.get('items') or {}
        return 'List of %s objects in this page of results.' % (words(ref_name(it)) or 'item')
    if prop in SPECIAL:
        return SPECIAL[prop].format(owner=o)
    w = words(prop.lstrip('_'))
    t = sch.get('type')
    if t == 'boolean':
        return 'Indicates whether the %s is %s.' % (o, w.replace('is ', '', 1)) if w.startswith('is ') else 'Indicates whether the %s has %s.' % (o, w)
    if t == 'array':
        return 'List of %s of the %s.' % (w, o)
    if sch.get('format') in ('date-time', 'datetime') or w.endswith(' on') or w.endswith(' at'):
        return 'Timestamp of the %s of the %s.' % (w, o)
    if t == 'integer':
        return 'Numeric %s of the %s.' % (w, o)
    return 'The %s of the %s.' % (w, o)
def fix_props(owner, node):
    if not isinstance(node, dict):
        return
    props = node.get('properties')
    if isinstance(props, dict):
        for k, v in props.items():
            if not isinstance(v, dict):
                continue
            if not v.get('description'):
                d = describe(owner, k, v)
                if '$ref' in v and len(v) == 1:
                    props[k] = {'allOf': [{'$ref': v['$ref']}], 'description': d}
                else:
                    v['description'] = d
            tgt = props[k]
            fix_props(owner + ' ' + k, tgt)
    for key in ('allOf', 'anyOf', 'oneOf'):
        for m in node.get(key, []) or []:
            fix_props(owner, m)
    if isinstance(node.get('items'), dict):
        fix_props(owner, node['items'])
for sname, sch in d['components']['schemas'].items():
    fix_props(sname, sch)

# 5. Blank response descriptions and request bodies without one ("undocumented return
#    parameter" / "undocumented parameter 'payload'"). spec_descriptions skips $ref bodies.
for path, item in d['paths'].items():
    for method, op in item.items():
        if not isinstance(op, dict) or 'responses' not in op:
            continue
        summ = (op.get('summary') or 'the operation').rstrip('.')
        for code, r in op['responses'].items():
            if isinstance(r, dict) and not (r.get('description') or '').strip():
                r['description'] = 'Success' if code.startswith('2') and not r.get('content') else 'Response for: ' + summ
        rb = op.get('requestBody')
        if isinstance(rb, dict) and '$ref' not in rb and not (rb.get('description') or '').strip():
            rb['description'] = 'Request payload for: ' + summ

for rname, rb in d.get('components', {}).get('requestBodies', {}).items():
    if isinstance(rb, dict) and not (rb.get('description') or '').strip():
        rb['description'] = 'Request payload containing the %s to submit.' % words(rname)
json.dump(d, open(f, 'w'), indent=2)
