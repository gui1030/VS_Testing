VeriSolutions - Cloud Application

Developer's SetUp Guide

1) This app sets ENV variables based on the Figaro gem.  To get the app running locally after you pull the code from github, you will need to create a file: config/application.yml.  (.gitignore is already set to ignore this file.)  

To this file add the following:

SECRET_KEY_BASE: dev-only:3c11fa675b1f160c9be5481aa844f3fcf09ee5a0481b92aa37ff6d4578325b235c62275b297d2d9e753e9cc6b704bfdd1882b4337f9f23fa6b91a18

### Database Access
DATABASE_USERNAME: veri_cloud
DEV_DATABASE_NAME: veri_cloud_development
TEST_DATABASE_NAME: veri_cloud_test
DATABASE_PASSWORD: dev-only:6d4578325b235c62275b297d2d9e675b1f160c9be5481aa844f3fcf09ee5a048

### Admin Access, first user
ADMIN_USERNAME: admin_user
ADMIN_PASSWORD: password

### Many other access keys to follow


2) Setting up the mysql Databases, development & test.

Assuming you already have mysql installed and running, from within the db folder run the following in Terminal to create the app-specific User.

mysql> source create_dev_only_user.sql

Next run the following to create the databases:

mysql> source rebuild_databases.sql

Check that the databases exist.

3) Using 'rake db:setup', successfully creates all the tables but does not add any seed data.
Also, it generates this error: 'Validation failed: Email is invalid'.

Using the console, one can run the following code to create an Admin User and an Account and get
the app running:

Admin.create([{ firstname: 'Admin', lastname: 'User', email: 'admin_user@example.com', 
                password: 'password' }])

Account.create([{name: 'Shire Eats', confirmed_at: DateTime.now, terms_accepted: true }])

The Admin.create will throw an error but the record is created.  One then manually sets the 'confirmed_at' attribute, using: confirmed_at ="2017-01-10 21:13:48".

