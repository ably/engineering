# Ably Engineering Team: Git Standards and Best Practices

This page contains notes specific to how we’re using Git with our open source (public) repositories.
There is more generic guidance [elsewhere](https://engineering.ably.com/wiki/spaces/PUB/pages/803766465/Ably+Development+Best+Practice), however anything noted in this page should take preference for client library work.

## Git Ignore (`.gitignore`) Files

We’re unlikely to ever have a repository that doesn’t eventually need a Git ignore file, in some cases a few of them (i.e. in sub-folders).

_The general principle is that these must be explicit and specific to the requirements of the particular codebase they’re included in._

This means:

- They should only contain rules that have been proven to be needed for this codebase
- Adoption of generic rule sets where rules may exist that haven’t been explicitly proven to be needed by this codebase is strongly discouraged

## `git` global ignore files

See [this blog post](https://sebastiandedeyne.com/setting-up-a-global-gitignore-file/), shared by [Tom Kirby-Green](https://github.com/tomkirbygreen) in [this Slack thread (internal)](https://ably-real-time.slack.com/archives/C0174D4AP4P/p1633669945023900?thread_ts=1633669607.022400&cid=C0174D4AP4P).

This may be tempting, but be aware that many users will not have this. So, for us to have true empathy for our developer users (mainly, in this case, contributors) then you might lose visibility in your day-to-day of what they're experiencing in terms of Git 'noise' if you use this git global configuration.
