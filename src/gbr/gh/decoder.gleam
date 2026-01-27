// Open issue in gleam repo
//
// https://github.com/gleam-lang/gleam/issues/4287
//
pub fn repo_decoder() {
  todo
  //   use id <- decode.field("id", decode.int)
  //   use node_id <- decode.field("node_id", decode.string)
  //   use name <- decode.field("name", decode.string)
  //   use full_name <- decode.field("full_name", decode.string)
  //   use private <- decode.field("private", decode.string)
  //   use owner <- decode.field("owner", org_decoder())
  //   use html_url <- decode.field("html_url", decode.string)
  //   use description <- decode.field("description", decode.string)
  //   use fork <- decode.field("fork", decode.string)
  //   use created_at <- decode.field("created_at", decode.string)
  //   use updated_at <- decode.field("updated_at", decode.string)
  //   use pushed_at <- decode.field("pushed_at", decode.string)
  //   use git_url <- decode.field("git_url", decode.string)
  //   use ssh_url <- decode.field("ssh_url", decode.string)
  //   use clone_url <- decode.field("clone_url", decode.string)
  //   use svn_url <- decode.field("svn_url", decode.string)
  //   use homepage <- decode.field("homepage", decode.string)
  //   use size <- decode.field("size", decode.string)
  //   use forks_count <- decode.field("forks_count", decode.int)
  //   use open_issues_count <- decode.field("open_issues_count", decode.int)
  //   use forks <- decode.field("forks", decode.bool)
  //   use open_issues <- decode.field("open_issues", decode.int)
  //   use watchers <- decode.field("watchers", decode.int)
  //   use default_branch <- decode.field("default_branch", decode.string)
  //   use permissions <- decode.field("permissions", permissions_decoder())
  //   use license <- decode.field("license", decode.string)

  //   use url <- decode.field("url", decode.string)
  //   use forks_url <- decode.field("forks_url", decode.string)
  //   use keys_url <- decode.field("keys_url", decode.string)
  //   use collaborators_url <- decode.field("collaborators_url", decode.string)
  //   use teams_url <- decode.field("teams_url", decode.string)
  //   use hooks_url <- decode.field("hooks_url", decode.string)
  //   use issue_events_url <- decode.field("issue_events", decode.string)
  //   use events_url <- decode.field("events_url", decode.string)
  //   use assignees_url <- decode.field("assignees_url", decode.string)
  //   use branches_url <- decode.field("branches_url", decode.string)
  //   use tags_url <- decode.field("tags_url", decode.string)
  //   use blobs_url <- decode.field("blobs_url", decode.string)
  //   use git_tags_url <- decode.field("git_tags_url", decode.string)
  //   use git_refs_url <- decode.field("git_refs_url", decode.string)
  //   use trees_url <- decode.field("trees_url", decode.string)
  //   use statuses_url <- decode.field("statuses_url", decode.string)
  //   use languages_url <- decode.field("languages_url", decode.string)
  //   use stargazers_url <- decode.field("stargazers_url", decode.string)
  //   use contributors_url <- decode.field("contributors_url", decode.string)
  //   use subscribers_url <- decode.field("subscribers_url", decode.string)
  //   use subscription_url <- decode.field("subscription_url", decode.string)
  //   use commits_url <- decode.field("commits_url", decode.string)
  //   use git_commits_url <- decode.field("git_commits_url", decode.string)
  //   use comments_url <- decode.field("comments_url", decode.string)
  //   use issue_comment_url <- decode.field("issue_comment_url", decode.string)
  //   use contents_url <- decode.field("contents_url", decode.string)
  //   use compare_url <- decode.field("compare_url", decode.string)
  //   use merges_url <- decode.field("merges_url", decode.string)
  //   use archive_url <- decode.field("archive_url", decode.string)
  //   use downloads_url <- decode.field("downloads_url", decode.string)
  //   use issues_url <- decode.field("issues_url", decode.string)
  //   use pulls_url <- decode.field("pulls_url", decode.string)
  //   use milestones_url <- decode.field("milestones_url", decode.string)
  //   use notifications_url <- decode.field("notification_url", decode.string)
  //   use labels_url <- decode.field("labels_url", decode.string)
  //   use releases_url <- decode.field("releases_url", decode.string)
  //   use deployments_url <- decode.field("deployments_url", decode.string)
  //   use stargazers_count <- decode.field("stargazers_count", decode.int)
  //   use watchers_count <- decode.field("watchers_count", decode.int)
  //   use language <- decode.field("language", decode.string)
  //   use has_issues <- decode.field("has_issues", decode.bool)
  //   use has_projects <- decode.field("has_projects", decode.bool)
  //   use has_downloads <- decode.field("has_downloads", decode.bool)
  //   use has_wiki <- decode.field("has_wiki", decode.bool)
  //   use has_pages <- decode.field("has_pages", decode.bool)
  //   use has_discussions <- decode.field("has_discussions", decode.bool)
  //   use mirror_url <- decode.field("mirror_url", decode.string)
  //   use archived <- decode.field("archived", decode.bool)
  //   use disabled <- decode.field("disabled", decode.bool)
  //   use allow_forking <- decode.field("allow_forking", decode.bool)
  //   use is_template <- decode.field("is_template", decode.bool)
  //   use web_commit_signoff_required <- decode.field(
  //     "web_commit_signoff_required",
  //     decode.bool,
  //   )
  //   use topics <- decode.field("topics", decode.list(decode.string))
  //   use visibility <- decode.field("visibility", decode.bool)

  //   GHRepo(
  //     id:,
  //     node_id:,
  //     name:,
  //     full_name:,
  //     private:,
  //     owner:,
  //     html_url:,
  //     description:,
  //     fork:,
  //     url:,
  //     forks_url:,
  //     keys_url:,
  //     collaborators_url:,
  //     teams_url:,
  //     hooks_url:,
  //     issue_events_url:,
  //     events_url:,
  //     assignees_url:,
  //     branches_url:,
  //     tags_url:,
  //     blobs_url:,
  //     git_tags_url:,
  //     git_refs_url:,
  //     trees_url:,
  //     statuses_url:,
  //     languages_url:,
  //     stargazers_url:,
  //     contributors_url:,
  //     subscribers_url:,
  //     subscription_url:,
  //     commits_url:,
  //     git_commits_url:,
  //     comments_url:,
  //     issue_comment_url:,
  //     contents_url:,
  //     compare_url:,
  //     merges_url:,
  //     archive_url:,
  //     downloads_url:,
  //     issues_url:,
  //     pulls_url:,
  //     milestones_url:,
  //     notifications_url:,
  //     labels_url:,
  //     releases_url:,
  //     deployments_url:,
  //     created_at:,
  //     updated_at:,
  //     pushed_at:,
  //     git_url:,
  //     ssh_url:,
  //     clone_url:,
  //     svn_url:,
  //     homepage:,
  //     size:,
  //     stargazers_count:,
  //     watchers_count:,
  //     language:,
  //     has_issues:,
  //     has_projects:,
  //     has_downloads:,
  //     has_wiki:,
  //     has_pages:,
  //     has_discussions:,
  //     forks_count:,
  //     mirror_url:,
  //     archived:,
  //     disabled:,
  //     open_issues_count:,
  //     license:,
  //     allow_forking:,
  //     is_template:,
  //     web_commit_signoff_required:,
  //     topics:,
  //     visibility:,
  //     forks:,
  //     open_issues:,
  //     watchers:,
  //     default_branch:,
  //     permissions:,
  //   )
  //   |> decode.success()
}
