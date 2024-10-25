# Set a custom session root path. Default is `$HOME`.
# Must be called before `initialize_session`.
session_root "~/workplace/FireFighterV2"

# Create session with specified name if it does not already exist. If no
# argument is given, session name will be based on layout file name.
if initialize_session "firefighter"; then
  # Create a new window inline within session layout definition.
  new_window "root"
  new_window "scripts"
  new_window "lambda"
  new_window "infra"
  new_window "ui"

  select_window "scripts"
  run_cmd "cd scripts"

  select_window "lambda"
  run_cmd "cd lambda"

  select_window "infra"
  run_cmd "cd infra"

  select_window "ui"
  run_cmd "cd ui"

  # Select the default active window on session creation.
  select_window "root"
fi

# Finalize session creation and switch/attach to it.
finalize_and_go_to_session
