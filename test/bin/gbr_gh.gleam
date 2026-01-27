import gleam/io
import gleam/javascript/promise
import gleam/list
import gleam/option.{None, Some}

import gbr/gh

pub fn main() {
  use root <- promise.map(gh.root())
  let assert Ok(root) = root

  io.println(">>> ROOT OK")
  io.println(root.current_user_url)

  use repos <- promise.map(gh.repos(
    "gleam-br",
    Some(gh.GHQuery(
      kind: Some("sources"),
      sort: None,
      direction: None,
      per_page: None,
      page: None,
    )),
  ))

  let assert Ok(repos) = repos

  io.print(">>> USER OK")
  let _ = {
    use repo <- list.map(repos)
    io.println(repo.name)
    io.println(repo.git_url)
  }

  Nil
}
