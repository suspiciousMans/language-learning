(* 02 — Domain modeling with ADTs *)

(* A small messaging domain *)

type message =
  | Text of string
  | Image of string * int * int  (* url, width, height *)
  | Video of string * int        (* url, duration_seconds *)
  | System of string            (* system notification *)

type user_status =
  | Offline
  | Online
  | Away of string            (* away message *)

type contact = {
  username: string;
  status: user_status;
  verified: bool;
}

type event =
  | MessageReceived of contact * message
  | UserStatusChanged of contact * user_status
  | UserJoined of contact
  | UserLeft of contact

(* TODO: write functions that work with this domain *)

let message_summary msg =
  match msg with
  | Text body -> "text: " ^ body
  | Image (url, w, h) -> Printf.sprintf "image: %s (%dx%d)" url (int_of_float w) (int_of_float h)
  | Video (url, dur) -> Printf.sprintf "video: %s (%ds)" url dur
  | System note -> "system: " ^ note

let status_icon status =
  match status with
  | Offline -> "○"
  | Online -> "●"
  | Away _ -> "◐"

(* EXERCISE:
   - Write `is_from_verified event` that returns true if the event's contact is verified.
   - Write `event_description e` that returns a human-readable string for each event.
   - Write `filter_messages list ~f` that keeps only messages matching a predicate.
   - Write `online_users list` that returns the usernames of online users.
   - Add a `Premium` status to user_status; update status_icon and event_description.
   - Add a `Link` message variant with a url; update message_summary.
   - Think: why is this domain easier to model with ADTs than with dictionaries or string tags?
*)
