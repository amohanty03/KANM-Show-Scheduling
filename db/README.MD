### Some useful information if you wish to make migration changes to the DB

Please remember to be absolutely sure of your changes before making migrations. 
We can always create a new app, if there happens to be some breaks, so not to worry.

Following are the steps that were following when adding a new column to the Admins table.

1. First run `rails generate migration AddRoleToAdmins role:integer`. This will generate the new migration file which adds a new column called `Role` to the `Admins` table.
2. Open the migration file and make any necessary modifications. In this particular example we will append to the role field entry the following : `, default:0`, setting the default value of 0.
3. Now run `rails db:migrate`
4. Later once code changes are committed and merged to master, we can run the commands to deploy on heroku:
    - `heroku login`
    - `heroku git:remote -a kanm-show-scheduler -r heroku-kanm` (we are renaming the origin here as heroku-kanm, kanm-show-scheduler is the app name, follow your own convention, it is local to you after all)
    - `git remote -v` (to check if the above origin was successfully added)
    - `git push heroku-kanm main`
5. Once you've pushed to heroku which will trigger the deployment, head to heroku and select `run console` and then enter `bash`.
6. Here run `rails db:migrate` to apply the migration changes to the deployment as well.
7. Run `rails db:seed` if any new seed data was added and should be present.