# KANM-Show-Scheduling

**Software Engineering CSCE 606 Team Project**

### Primary Links

- Deployed App - https://kanm-show-scheduler-b962465e9890.herokuapp.com/

- Team working document - https://github.com/amohanty03/KANM-Show-Scheduling/blob/main/documentation/Fall2024/Team_Working_Agreement.txt

- Pivotal - https://www.pivotaltracker.com/n/projects/2721031

- Slack - https://app.slack.com/client/T07NSND4DJ8/C07PD2K9U2U

- GitHub - https://github.com/amohanty03/KANM-Show-Scheduling

- Code Climate Report - https://codeclimate.com/github/amohanty03/KANM-Show-Scheduling


### Team Members

- Ali Nablan
- Ankit Mohanty
- Davis Beilue
- Haridher Pandiyan
- James Nojek
- Kriti Sarker
- Neeraj Julian Joseph Rajkumar
- Toan Vu


### Getting Started in Local

- For the very first time, please run `bundle config set --local without 'production' && bundle install`. 
- Anytime after that, if the `Gemfile` gets updated, simply run `bundle install`.
- There is a credentials.yml.enc file. It needs to be regenerated, meanwhile rename the old one.
- Once renamed, run `EDITOR=nano rails credentials:edit`. Paste the shared credentials into this file.
- A `master.key` and `credentials.yml.enc` will be generated.
- Apply migrations via `rails db:migrate`.
- Seed the DB via `rails db:seed`.
- Finally start the server via `rails server`.


### Testing and Coverage 

- Run `bundle exec cucumber` . All testcases should pass.
- Run `bundle exec rspec` . All testcases should pass.
View the coverage report summary at `coverage/.last_run.json`.
View the detailed coverage report at `coverage/index.html` .


### Rubocop

Please run ` rubocop --format simple --out reports/rubocop_summary.txt `.
View the report at `reports/rubocop_summary.txt`.

Forking this repo to test if everything works.

***Ruby version : 3.3.4***