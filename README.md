# KANM-Show-Scheduling

**Software Engineering CSCE 606 Team Project**

### Primary Links

- Deployed App - https://kanm-show-scheduler-b962465e9890.herokuapp.com/

- Team working document - https://github.com/amohanty03/KANM-Show-Scheduling/blob/main/documentation/Fall2024/Team_Working_Agreement.txt

- Pivotal - https://www.pivotaltracker.com/n/projects/2721031

- Slack - https://app.slack.com/client/T07NSND4DJ8/C07PD2K9U2U

- GitHub - https://github.com/amohanty03/KANM-Show-Scheduling

- Code Climate Report - https://codeclimate.com/github/amohanty03/KANM-Show-Scheduling


***NOTE*** : For Project Verification steps, please scroll to the bottom of this Readme and follow the instructions.


### Team Members

- Ali Nablan (aln170001@tamu.edu)
- Ankit Mohanty (amohanty03@tamu.edu)
- Davis Beilue (davis.beilue@tamu.edu)
- Haridher Pandiyan (haridher@tamu.edu)
- James Nojek (jnojek13@tamu.edu)
- Kriti Sarker (sarkriti@tamu.edu)
- Neeraj Julian Joseph Rajkumar (njulian@tamu.edu)
- Toan Vu (toanvpk@tamu.edu)


### Getting Started in Local

1. For the very first time, please run `bundle config set --local without 'production' && bundle install`. 
2. Anytime after that, if the `Gemfile` gets updated, simply run `bundle install`.
3. Substeps for Google Auth :
   1. Now since we have Google Auth enabled, you will either need to :
     - make your own GCP project and follow the [Google Auth Setup Readme](https://github.com/tamu-edu-students/Google-Auth-Ruby-By-JD) partially, in order to get your google client id and secret *OR* 
     - you could just yours our currently setup GCP project. But for this, you will need to submit an issue request to us, requesting for access and we will share the required client id and secret.
   2.  The client id and secret will be used to generate the `credentials.yml.enc` file. The one in this repo, is used by our current deployment on Heroku. For your local, you need to generate your own file, following the next steps.
   3. Here we're assuming you have rails installed in your *Linux* terminal, along with *nano* editor (for different terminals and editor, make appropriate changes).
   4. Run `EDITOR=nano rails credentials:edit`. Paste the shared credentials into this file.
   5. A `master.key` and `credentials.yml.enc` files will be generated.
4. Apply migrations via `rails db:migrate`.
5. Seed the DB via `rails db:seed`. If you require superuser access to manage admins, you can add yourself here.
6. Finally start the server via `rails server`.


### Deploying this Application on Heroku
- Go to the **Heroku** website and create a new app (say kanm-pv).
- Open this app. Go to **Resources** and click "Find more add-ons". Here select **Heroku Postgres** and then the "Essential0" (0.007$/hr) plan. Submit this order.
- From your terminal, login to heroku via `heroku login`.
- Now we will create a new heroku remote, so that we can push the current codebase to it. Please run `heroku git:remote -a <your-new-app-name> -r <heroku-new-remote-name>` (Say `heroku git:remote -a kanm-pv -r heroku-pv`). The -r flag lets you rename the remote, so pick a unique name so that it doesn't clash with any existing deployments you may have.
- Run `git remote` to verify that its been added.
- Next run `heroku push <your-heroku-remote-name> main` (say `heroku push heroku-pv main`). This should succeed.
- Next go to your Heroku app page, and open up a bash console there. Then run `rails db:migrate` and `rails db:seed`.
- Now on your Heroku app page, click the button "Open App" to view the deployed application. You should successfully see the required home page of our application. Note the URL here.
- Before you try logging in, you need to add the callback to Google Auth. Hence the URL for this will be based on the above URL you got from the previous step, but substitute the `/login/index` with `/auth/google_oauth2/callback` (Say like https://kanm-pv-bdd730616f63.herokuapp.com/auth/google_oauth/callback`) . If you are using our GCP application, contact our team to get it added, else add to your own GCP project.
- Once added, you are good to go. Try logging in again and you should hopefully succeed. 
- You should be able to view the welcome and calendar pages. The admin pages require you to be granted superuser status for the project. This can be done via adding yourself in the `seeds.rb` file and running `rails db:seed`. After which you can admins as you please with your superuser status via the "Manage Admins" button available at the button below your profile icon.


### Testing and Coverage 

- For Cucumber tests (BDD), please run `bundle exec cucumber` . All testcases should pass.
- For RSpec tests (TDD), please run `bundle exec rspec` . All testcases should pass.
View the coverage report summary at `coverage/.last_run.json`.
View the detailed coverage report at `coverage/index.html` .


### Rubocop

Please run ` rubocop --format simple --out reports/rubocop_summary.txt `.
View the report at `reports/rubocop_summary.txt`.


### Project Verification Steps

1. Clone our Repo - `git clone https://github.com/amohanty03/KANM-Show-Scheduling.git`.
2. Please read through this entire Readme before starting out with anything. :)
3. [Getting Started in Local](#getting-started-in-local).
4. [Deploying the application on Heroku](#deploying-this-application-on-heroku).
5. [Testing and Coverage](#testing-and-coverage).
6. For any questions or issues troubleshooting this project, please reach out to any of the [Team Members](#team-members) mentioned above.

***Ruby version : 3.3.4***