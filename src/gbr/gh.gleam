////
//// Github REST API v3 client
////

import gleam/bool
import gleam/dynamic.{type Dynamic}
import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/javascript/promise
import gleam/list
import gleam/option.{type Option, None, Some}

/// Fetch "/" root github resources
///
/// Return all init urls
///
pub fn root() -> promise.Promise(Result(GHRoot, List(decode.DecodeError))) {
  fetch(path: "/", method: http.Get, options: None)
  |> promise.map(fn(dyn) { decode.run(dyn, root_decoder()) })
}

/// Fetch organization by name
///
/// - name: Org name
/// - query: Query filter
///
pub fn org(
  name: String,
  query: Option(GHQuery),
) -> promise.Promise(Result(GHOrg, List(decode.DecodeError))) {
  let options =
    query
    |> to_query()
    |> option.map(fn(query) {
      GHApiOptions(
        query: Some(query),
        path: None,
        header: None,
        cookie: None,
        body: None,
      )
    })

  fetch(path: "/orgs/" <> name, method: http.Get, options:)
  |> promise.map(fn(dyn) { decode.run(dyn, org_decoder()) })
}

/// Fetch repositories from org name filtering or not
///
/// - org: Org name
/// - query: Query filter
///
pub fn repos(
  org: String,
  query: Option(GHQuery),
) -> promise.Promise(Result(List(GHRepoSimple), List(decode.DecodeError))) {
  let options =
    query
    |> to_query()
    |> option.map(fn(query) {
      GHApiOptions(
        query: Some(query),
        path: None,
        header: None,
        cookie: None,
        body: None,
      )
    })

  fetch(path: "/orgs/" <> org <> "/repos", method: http.Get, options:)
  |> promise.map(fn(dyn) {
    decode.run(dyn |> echo, repo_decoder() |> decode.list())
  })
}

/// Fetch github api from url
///
/// - path: Github api path
/// - method: Http method
/// - options: Github api options { query, path, header, cookie, body}
///
pub fn fetch(
  path path: String,
  method method: http.Method,
  options options: Option(GHApiOptions),
) -> promise.Promise(Dynamic) {
  let method = http.method_to_string(method)
  let opt = opt_to_dynamic(options)

  do_fetch(path:, method:, opt:)
}

/// Github response from "/" root.
///
pub type GHRoot {
  GHRoot(
    current_user_url: String,
    current_user_authorizations_html_url: String,
    authorizations_url: String,
    code_search_url: String,
    commit_search_url: String,
    emails_url: String,
    emojis_url: String,
    events_url: String,
    feeds_url: String,
    followers_url: String,
    following_url: String,
    gists_url: String,
    hub_url: String,
    issue_search_url: String,
    issues_url: String,
    keys_url: String,
    label_search_url: String,
    notifications_url: String,
    organization_url: String,
    organization_repositories_url: String,
    organization_teams_url: String,
    public_gists_url: String,
    rate_limit_url: String,
    repository_url: String,
    repository_search_url: String,
    current_user_repositories_url: String,
    starred_url: String,
    starred_gists_url: String,
    topic_search_url: String,
    user_url: String,
    user_organizations_url: String,
    user_repositories_url: String,
    user_search_url: String,
  )
}

/// Github reponse from "/orgs/{name}"
///
pub type GHOrg {
  GHOrg(
    id: Int,
    login: String,
    node_id: String,
    url: String,
    repos_url: String,
    events_url: String,
    hooks_url: String,
    issues_url: String,
    members_url: String,
    public_members_url: String,
    avatar_url: String,
    description: String,
    name: String,
    company: String,
    blog: String,
    location: String,
    email: String,
    twitter_username: String,
    is_verified: Bool,
    has_organization_projects: Bool,
    has_repository_projects: Bool,
    public_repos: Int,
    public_gists: Int,
    followers: Int,
    following: Int,
    html_url: String,
    created_at: String,
    updated_at: String,
    archived_at: String,
    kind: String,
  )
}

pub type GHApiOptions {
  GHApiOptions(
    query: Option(List(#(String, String))),
    header: Option(List(#(String, String))),
    path: Option(List(#(String, String))),
    cookie: Option(List(#(String, String))),
    body: Option(String),
  )
}

pub type GHQuery {
  GHQuery(
    // "all" | "public" | "private" | "forks" | "sources" | "member" | "internal";
    kind: Option(String),
    //"created" | "updated" | "pushed" | "full_name";
    sort: Option(String),
    // "asc" | "desc";
    direction: Option(String),
    per_page: Option(Int),
    page: Option(Int),
  )
}

// PRIVATE
//

@external(javascript, "./gh/gh_ffi.ts", "api_github_oas_fetch")
fn do_fetch(
  path path: String,
  method method: String,
  opt options: Dynamic,
) -> promise.Promise(Dynamic)

fn opt_to_dynamic(opt: Option(GHApiOptions)) -> Dynamic {
  use <- bool.guard(option.is_none(opt), dynamic.nil())
  let assert Some(GHApiOptions(query:, header:, path:, cookie:, body:)) = opt
  let to_parameter = fn(param) {
    param
    |> option.map(fn(q) {
      use #(key, value) <- list.map(q)
      #(dynamic.string(key), dynamic.string(value))
    })
    |> option.unwrap([])
  }

  let parameters =
    dynamic.properties([
      #(dynamic.string("query"), to_parameter(query) |> dynamic.properties()),
      #(dynamic.string("header"), to_parameter(header) |> dynamic.properties()),
      #(dynamic.string("path"), to_parameter(path) |> dynamic.properties()),
      #(dynamic.string("cookie"), to_parameter(cookie) |> dynamic.properties()),
    ])
  let body =
    body
    |> option.map(dynamic.string)
    |> option.unwrap(dynamic.nil())

  dynamic.properties([
    #(dynamic.string("parameters"), parameters),
    #(dynamic.string("requestBody"), body),
  ])
}

pub type GHRepoSimple {
  GHRepoSimple(
    //   id: 1104548631,
    id: Int,
    //   node_id: 'R_kgDOQdYTFw',
    node_id: String,
    //   name: 'gbr-ui-demo',
    name: String,
    //   full_name: 'gleam-br/gbr-ui-demo',
    full_name: String,
    //   private: false,
    forks_count: Int,
    //   html_url: 'https://github.com/gleam-br/gbr-ui-demo',
    html_url: String,
    //   description: 'Demo: Vite + Lustre + Gleam language',
    description: Option(String),
    //   fork: false,
    fork: Bool,
    //   created_at: '2025-11-26T11:09:09Z',
    created_at: String,
    //   updated_at: '2025-11-26T11:27:18Z',
    updated_at: String,
    //   pushed_at: '2025-11-26T11:27:14Z',
    pushed_at: String,
    //   git_url: 'git://github.com/gleam-br/gbr-ui-demo.git',
    git_url: String,
    //   ssh_url: 'git@github.com:gleam-br/gbr-ui-demo.git',
    ssh_url: String,
    //   clone_url: 'https://github.com/gleam-br/gbr-ui-demo.git',
    clone_url: String,
    //   homepage: null,
    homepage: Option(String),
    //   size: 312,
    size: Int,
    //   open_issues_count: 0,
    open_issues_count: Int,
    //   license: null,
    license: Option(GHLicense),
    //   forks: 0,
    forks: Int,
    //   open_issues: 0,
    open_issues: Int,
    //   watchers: 0,
    watchers: Int,
    //   default_branch: 'main',
    default_branch: String,
    //   permissions: {
    permissions: GHPermissions,
  )
}

pub type GHLicense {
  GHLicense(
    key: Option(String),
    name: Option(String),
    spdx_id: Option(String),
    url: Option(String),
    node_id: Option(String),
  )
}

fn license_decoder() {
  use key <- decode.field("key", decode.optional(decode.string))
  use name <- decode.field("name", decode.optional(decode.string))
  use spdx_id <- decode.field("spdx_id", decode.optional(decode.string))
  use url <- decode.field("url", decode.optional(decode.string))
  use node_id <- decode.field("node_id", decode.optional(decode.string))

  GHLicense(key:, name:, spdx_id:, url:, node_id:)
  |> decode.success()
}

fn repo_decoder() {
  use id <- decode.field("id", decode.int)
  use node_id <- decode.field("node_id", decode.string)
  use name <- decode.field("name", decode.string)
  use full_name <- decode.field("full_name", decode.string)
  use html_url <- decode.field("html_url", decode.string)
  use description <- decode.field("description", decode.optional(decode.string))
  use created_at <- decode.field("created_at", decode.string)
  use updated_at <- decode.field("updated_at", decode.string)
  use pushed_at <- decode.field("pushed_at", decode.string)
  use git_url <- decode.field("git_url", decode.string)
  use ssh_url <- decode.field("ssh_url", decode.string)
  use clone_url <- decode.field("clone_url", decode.string)
  use homepage <- decode.field("homepage", decode.optional(decode.string))
  use size <- decode.field("size", decode.int)
  use forks_count <- decode.field("forks_count", decode.int)
  use open_issues_count <- decode.field("open_issues_count", decode.int)
  use fork <- decode.field("fork", decode.bool)
  use forks <- decode.field("forks", decode.int)
  use open_issues <- decode.field("open_issues", decode.int)
  use watchers <- decode.field("watchers", decode.int)
  use default_branch <- decode.field("default_branch", decode.string)
  use permissions <- decode.field("permissions", permissions_decoder())
  use license <- decode.field("license", decode.optional(license_decoder()))

  GHRepoSimple(
    id:,
    node_id:,
    name:,
    full_name:,
    forks_count:,
    html_url:,
    description:,
    fork:,
    created_at:,
    updated_at:,
    pushed_at:,
    git_url:,
    ssh_url:,
    clone_url:,
    homepage:,
    size:,
    open_issues_count:,
    license:,
    forks:,
    open_issues:,
    watchers:,
    default_branch:,
    permissions:,
  )
  |> decode.success()
}

pub type GHRepo {
  GHRepo(
    //   id: 1104548631,
    id: Int,
    //   node_id: 'R_kgDOQdYTFw',
    node_id: String,
    //   name: 'gbr-ui-demo',
    name: String,
    //   full_name: 'gleam-br/gbr-ui-demo',
    full_name: String,
    //   private: false,
    private: Bool,
    //   owner: {
    //     login: 'gleam-br',
    //     id: 149188817,
    //     node_id: 'O_kgDOCORw0Q',
    //     avatar_url: 'https://avatars.githubusercontent.com/u/149188817?v=4',
    //     gravatar_id: '',
    //     url: 'https://api.github.com/users/gleam-br',
    //     html_url: 'https://github.com/gleam-br',
    //     followers_url: 'https://api.github.com/users/gleam-br/followers',
    //     following_url: 'https://api.github.com/users/gleam-br/following{/other_user}',
    //     gists_url: 'https://api.github.com/users/gleam-br/gists{/gist_id}',
    //     starred_url: 'https://api.github.com/users/gleam-br/starred{/owner}{/repo}',
    //     subscriptions_url: 'https://api.github.com/users/gleam-br/subscriptions',
    //     organizations_url: 'https://api.github.com/users/gleam-br/orgs',
    //     repos_url: 'https://api.github.com/users/gleam-br/repos',
    //     events_url: 'https://api.github.com/users/gleam-br/events{/privacy}',
    //     received_events_url: 'https://api.github.com/users/gleam-br/received_events',
    //     type: 'Organization',
    //     user_view_type: 'public',
    //     site_admin: false
    //   },
    owner: GHOrg,
    //   html_url: 'https://github.com/gleam-br/gbr-ui-demo',
    html_url: String,
    //   description: 'Demo: Vite + Lustre + Gleam language',
    description: String,
    //   fork: false,
    fork: Bool,
    //   url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo',
    url: String,
    //   forks_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/forks',
    forks_url: String,
    //   keys_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/keys{/key_id}',
    keys_url: String,
    //   collaborators_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/collaborators{/collaborator}',
    collaborators_url: String,
    //   teams_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/teams',
    teams_url: String,
    //   hooks_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/hooks',
    hooks_url: String,
    //   issue_events_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/issues/events{/number}',
    issue_events_url: String,
    //   events_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/events',
    events_url: String,
    //   assignees_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/assignees{/user}',
    assignees_url: String,
    //   branches_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/branches{/branch}',
    branches_url: String,
    //   tags_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/tags',
    tags_url: String,
    //   blobs_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/git/blobs{/sha}',
    blobs_url: String,
    //   git_tags_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/git/tags{/sha}',
    git_tags_url: String,
    //   git_refs_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/git/refs{/sha}',
    git_refs_url: String,
    //   trees_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/git/trees{/sha}',
    trees_url: String,
    //   statuses_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/statuses/{sha}',
    statuses_url: String,
    //   languages_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/languages',
    languages_url: String,
    //   stargazers_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/stargazers',
    stargazers_url: String,
    //   contributors_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/contributors',
    contributors_url: String,
    //   subscribers_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/subscribers',
    subscribers_url: String,
    //   subscription_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/subscription',
    subscription_url: String,
    //   commits_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/commits{/sha}',
    commits_url: String,
    //   git_commits_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/git/commits{/sha}',
    git_commits_url: String,
    //   comments_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/comments{/number}',
    comments_url: String,
    //   issue_comment_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/issues/comments{/number}',
    issue_comment_url: String,
    //   contents_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/contents/{+path}',
    contents_url: String,
    //   compare_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/compare/{base}...{head}',
    compare_url: String,
    //   merges_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/merges',
    merges_url: String,
    //   archive_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/{archive_format}{/ref}',
    archive_url: String,
    //   downloads_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/downloads',
    downloads_url: String,
    //   issues_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/issues{/number}',
    issues_url: String,
    //   pulls_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/pulls{/number}',
    pulls_url: String,
    //   milestones_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/milestones{/number}',
    milestones_url: String,
    //   notifications_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/notifications{?since,all,participating}',
    notifications_url: String,
    //   labels_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/labels{/name}',
    labels_url: String,
    //   releases_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/releases{/id}',
    releases_url: String,
    //   deployments_url: 'https://api.github.com/repos/gleam-br/gbr-ui-demo/deployments',
    deployments_url: String,
    //   created_at: '2025-11-26T11:09:09Z',
    created_at: String,
    //   updated_at: '2025-11-26T11:27:18Z',
    updated_at: String,
    //   pushed_at: '2025-11-26T11:27:14Z',
    pushed_at: String,
    //   git_url: 'git://github.com/gleam-br/gbr-ui-demo.git',
    git_url: String,
    //   ssh_url: 'git@github.com:gleam-br/gbr-ui-demo.git',
    ssh_url: String,
    //   clone_url: 'https://github.com/gleam-br/gbr-ui-demo.git',
    clone_url: String,
    //   svn_url: 'https://github.com/gleam-br/gbr-ui-demo',
    svn_url: String,
    //   homepage: null,
    homepage: String,
    //   size: 312,
    size: Int,
    //   stargazers_count: 0,
    stargazers_count: Int,
    //   watchers_count: 0,
    watchers_count: Int,
    //   language: 'Gleam',
    language: String,
    //   has_issues: true,
    has_issues: Bool,
    //   has_projects: true,
    has_projects: Bool,
    //   has_downloads: true,
    has_downloads: Bool,
    //   has_wiki: true,
    has_wiki: Bool,
    //   has_pages: false,
    has_pages: Bool,
    //   has_discussions: false,
    has_discussions: Bool,
    //   forks_count: 0,
    forks_count: Int,
    //   mirror_url: null,
    mirror_url: String,
    //   archived: false,
    archived: Bool,
    //   disabled: false,
    disabled: Bool,
    //   open_issues_count: 0,
    open_issues_count: Int,
    //   license: null,
    license: String,
    //   allow_forking: true,
    allow_forking: Bool,
    //   is_template: false,
    is_template: Bool,
    //   web_commit_signoff_required: false,
    web_commit_signoff_required: Bool,
    //   topics: [],
    topics: List(String),
    //   visibility: 'public',
    visibility: String,
    //   forks: 0,
    forks: Int,
    //   open_issues: 0,
    open_issues: Int,
    //   watchers: 0,
    watchers: Int,
    //   default_branch: 'main',
    default_branch: String,
    //   permissions: {
    permissions: GHPermissions,
  )
}

pub type GHPermissions {
  GHPermissions(
    admin: Bool,
    maintain: Bool,
    push: Bool,
    triage: Bool,
    pull: Bool,
  )
}

pub fn permissions_decoder() {
  use admin <- decode.field("admin", decode.bool)
  use maintain <- decode.field("maintain", decode.bool)
  use push <- decode.field("push", decode.bool)
  use triage <- decode.field("triage", decode.bool)
  use pull <- decode.field("pull", decode.bool)

  GHPermissions(admin:, maintain:, pull:, push:, triage:)
  |> decode.success()
}

/// Github root decoder dynamic response
///
pub fn root_decoder() {
  use current_user_url <- decode.field("current_user_url", decode.string)
  use current_user_authorizations_html_url <- decode.field(
    "current_user_authorizations_html_url",
    decode.string,
  )
  use authorizations_url <- decode.field("authorizations_url", decode.string)
  use code_search_url <- decode.field("code_search_url", decode.string)
  use commit_search_url <- decode.field("commit_search_url", decode.string)
  use emails_url <- decode.field("emails_url", decode.string)
  use emojis_url <- decode.field("emojis_url", decode.string)
  use events_url <- decode.field("events_url", decode.string)
  use feeds_url <- decode.field("feeds_url", decode.string)
  use followers_url <- decode.field("followers_url", decode.string)
  use following_url <- decode.field("following_url", decode.string)
  use gists_url <- decode.field("gists_url", decode.string)
  use hub_url <- decode.field("hub_url", decode.string)
  use issue_search_url <- decode.field("issue_search_url", decode.string)
  use issues_url <- decode.field("issues_url", decode.string)
  use keys_url <- decode.field("keys_url", decode.string)
  use label_search_url <- decode.field("label_search_url", decode.string)
  use notifications_url <- decode.field("notifications_url", decode.string)
  use organization_url <- decode.field("organization_url", decode.string)
  use organization_repositories_url <- decode.field(
    "organization_repositories_url",
    decode.string,
  )
  use organization_teams_url <- decode.field(
    "organization_teams_url",
    decode.string,
  )
  use public_gists_url <- decode.field("public_gists_url", decode.string)
  use rate_limit_url <- decode.field("rate_limit_url", decode.string)
  use repository_url <- decode.field("repository_url", decode.string)
  use repository_search_url <- decode.field(
    "repository_search_url",
    decode.string,
  )
  use current_user_repositories_url <- decode.field(
    "current_user_repositories_url",
    decode.string,
  )
  use starred_url <- decode.field("starred_url", decode.string)
  use starred_gists_url <- decode.field("starred_gists_url", decode.string)
  use topic_search_url <- decode.field("topic_search_url", decode.string)
  use user_url <- decode.field("user_url", decode.string)
  use user_organizations_url <- decode.field(
    "user_organizations_url",
    decode.string,
  )
  use user_repositories_url <- decode.field(
    "user_repositories_url",
    decode.string,
  )
  use user_search_url <- decode.field("user_search_url", decode.string)

  GHRoot(
    current_user_url:,
    current_user_authorizations_html_url:,
    authorizations_url:,
    code_search_url:,
    commit_search_url:,
    emails_url:,
    emojis_url:,
    events_url:,
    feeds_url:,
    followers_url:,
    following_url:,
    gists_url:,
    hub_url:,
    issue_search_url:,
    issues_url:,
    keys_url:,
    label_search_url:,
    notifications_url:,
    organization_url:,
    organization_repositories_url:,
    organization_teams_url:,
    public_gists_url:,
    rate_limit_url:,
    repository_url:,
    repository_search_url:,
    current_user_repositories_url:,
    starred_url:,
    starred_gists_url:,
    topic_search_url:,
    user_url:,
    user_organizations_url:,
    user_repositories_url:,
    user_search_url:,
  )
  |> decode.success()
}

pub fn org_decoder() {
  use id <- decode.field("id", decode.int)
  use login <- decode.field("login", decode.string)
  use node_id <- decode.field("node_id", decode.string)
  use url <- decode.field("url", decode.string)
  use repos_url <- decode.field("repos_url", decode.string)
  use events_url <- decode.field("events_url", decode.string)
  use hooks_url <- decode.field("hooks_url", decode.string)
  use issues_url <- decode.field("issues_url", decode.string)
  use members_url <- decode.field("members_url", decode.string)
  use public_members_url <- decode.field("public_members", decode.string)
  use avatar_url <- decode.field("avatar_url", decode.string)
  use description <- decode.field("description", decode.string)
  use name <- decode.field("name", decode.string)
  use company <- decode.field("company", decode.string)
  use blog <- decode.field("blog", decode.string)
  use location <- decode.field("location", decode.string)
  use email <- decode.field("email", decode.string)
  use twitter_username <- decode.field("twitter_username", decode.string)
  use is_verified <- decode.field("is_verified", decode.bool)
  use has_organization_projects <- decode.field(
    "has_organization_projects",
    decode.bool,
  )
  use has_repository_projects <- decode.field(
    "has_repository_projects",
    decode.bool,
  )
  use public_repos <- decode.field("public_repos", decode.int)
  use public_gists <- decode.field("public_gists", decode.int)
  use followers <- decode.field("followers", decode.int)
  use following <- decode.field("following", decode.int)
  use html_url <- decode.field("html_url", decode.string)
  use created_at <- decode.field("created_at", decode.string)
  use updated_at <- decode.field("updated_at", decode.string)
  use archived_at <- decode.field("archived_at", decode.string)
  use kind <- decode.field("", decode.string)

  GHOrg(
    id:,
    login:,
    node_id:,
    url:,
    repos_url:,
    events_url:,
    hooks_url:,
    issues_url:,
    members_url:,
    public_members_url:,
    avatar_url:,
    description:,
    name:,
    company:,
    blog:,
    location:,
    email:,
    twitter_username:,
    is_verified:,
    has_organization_projects:,
    has_repository_projects:,
    public_repos:,
    public_gists:,
    followers:,
    following:,
    html_url:,
    created_at:,
    updated_at:,
    archived_at:,
    kind:,
  )
  |> decode.success()
}

pub fn to_query(query: Option(GHQuery)) {
  query
  |> option.map(fn(query) {
    [
      #("type", query.kind |> option.unwrap("")),
      #("sort", query.sort |> option.unwrap("")),
      #("direction", query.direction |> option.unwrap("")),
      #("page", query.page |> option.map(int.to_string) |> option.unwrap("")),
      #(
        "per-page",
        query.per_page |> option.map(int.to_string) |> option.unwrap(""),
      ),
    ]
  })
}
