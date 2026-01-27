import gleam/dynamic/decode
import gleam/http
import gleam/io
import gleam/javascript/promise
import gleam/list
import gleam/option.{None, Some}
import gleam/string

import gbr/gh
import gbr/shared/error

pub fn main() {
  use root <- promise.map(gh.root())

  case root {
    Ok(_root) -> {
      use user <- promise.map(gh.repos(
        "gleam-br",
        Some(gh.GHQuery(
          kind: Some("sources"),
          sort: None,
          direction: None,
          per_page: None,
          page: None,
        )),
      ))
      case user {
        Ok(user) -> {
          io.print(">>> USER OK")
          echo user
          Nil
        }
        Error(err) -> {
          list.map(err, error.decode_to_string)
          |> string.join("\n")
          |> io.print_error()
          Nil
        }
      }
      Nil
    }
    Error(err) -> {
      list.map(err, error.decode_to_string)
      |> string.join("\n")
      |> io.print_error()

      promise.resolve(Nil)
    }
  }
}
