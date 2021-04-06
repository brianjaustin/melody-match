ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(MelodyMatch.Repo, :manual)

Mox.defmock(MelodyMatch.Matchmaker.MatcherMock,
  for: MelodyMatch.Matchmaker.MatcherBase)

Application.put_env(:melody_match, :default_matcher,
  MelodyMatch.Matchmaker.MatcherMock)
