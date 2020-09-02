# Annotation Studio
An annotation platform designed for teaching and learning in the humanities,
and with aspirations to more general use.

## Works with: MIT Annotation Data Store
There are two servers required to run this application. This one, and the [MIT
Annotation Data Store](https://github.com/hyperstudio/MIT-Annotation-Data-Store
).

You __MUST__ get the Annotation server running to be able to create or view
annotations.

# Getting Started

## How to run with Docker

You need `docker` and `docker-compose` installed (for MacOS just use [official app](https://docs.docker.com/engine/installation/mac/)).

## Provisioning

Run the following commands to prepare your Docker dev env:

```sh
$ docker-compose build
$ docker-compose run runner yarn install
$ docker-compose run runner ./bin/setup
```

It builds the Docker image, installs Ruby and NodeJS dependencies, creates database, run migrations and seeds.

You're all set! Now you're ready to code!

## Commands

- Running the app:

You can run the Rails up using the following command:

```sh
$ docker-compose up rails
```

If you want to run Webpack Dev server as well:

```sh
$ docker-compose up rails webpacker
```

## Dip

You can also use [`dip`](https://github.com/bibendi/dip)?CLI utility for straightforward provisioning and interacting with an applications configured by `docker-compose`.

To install `dip` copy and run the command below:

```sh
$ gem install dip
```

Then use the following commands:

```sh
# provision application
dip provision

# run web app with all debuging capabilities (i.e. `binding.pry`)
dip rails s

# run rails console
dip rails c

# run webpacker dev server
dip up -d webpacker
# `-d` - mean that service will run in detached (background) mode
```

## Things to install
Annotation Studio uses PostgreSQL and Ruby

The MIT Annotation Data Store requires Node.js, NPM and MongoDB

## General Installation
Use rbenv or rvm to install and run the Ruby version specified in `.ruby-version`.

(optional additional software: [thoughtbot's Laptop repo](https://github.com/thoughtbot/laptop))

```
git clone https://github.com/hyperstudio/Annotation-Studio.git
cd Annotation-Studio
./bin/setup
```

which will:

* Drop existing databases
* Run migrations and prepare the test database
* Seed the application
* Install the MIT Annotation Data Store under `./tmp/annotation_data_store`
* Create an example application.yml

After setting up the app, run:

```bash
bundle exec foreman start -f Procfile.dev
```

to spin up development dependencies. You can exist the development daemons by
hitting ctrl-c, per normal unix semantics.

### Installation on Heroku
If you would like to run the application on Heroku (recommended), do the
following

- Create a Heroku app `heroku apps:create $APPNAME`
- Add the Heroku PostgreSQL add-on `heroku addons:add heroku-postgresql`
  - Don't worry about providing db configuration, [Heroku will do it for you]
(https://devcenter.heroku.com/articles/heroku-postgresql#connecting-in-rails)
- Use Figaro to load your `application.yml` into environment variables and
communicate them to Heroku
  -  `rake figaro:heroku[$APPNAME]`

### Multitenancy
This app uses the [apartment gem](http://github.com/influitive/apartment) to allow multiple domains to be hosted in a single instance.  

To create a new tenant:

1. Log in via an AdminUser account to http://www.your-app-url.com/admin/
1. Add a Tenant record, with the full hostname at which you want users to access the application, and the name of the database to be used to store the tenant's data
1. Configure DNS for that domain (or subdomain), pointing it to the URL of the application
1. Add the domain in question to the web server configuration for the application

#### Caveats
1. If a domain does not have a matching Tenant, the default "public" tenant will be used.
2. Admin users are shared across all tenants, and therefore shouldn't be created and granted to single-tenant users

## User Support and Developer forum
http://support.annotationstudio.org

## Thanks
Thanks to:
- [NEH Office of Digital Humanities](http://www.neh.gov/odh) who has funded
this project
- [OKFN](http://okfn.org/) for supporting [The Annotator]
(http://annotatorjs.org)
- [Nick Stenning](https://github.com/nickstenning/) for being awesome and for
leading the Annotator developer team
- [Dan Whaley, Randall Leeds and hypothes.is](https://hypothes.is/) for being
awesome and supporting the Annotator Community
- [The Annotator community](https://github.com/openannotation/annotator/) for
plugins and being awesome.

## Contributors
### Institutions
- Active Archives Initiative at MIT
- http://aai.mit.edu
- MIT HyperStudio
- http://hyperstudio.mit.edu/

### Developers
- Jamie Folsom [@jamiefolsom](http://github.com/jamiefolsom)
- Liam Andrew [@mailbackwards](http://github.com/mailbackwards)
- Andrew Magliozzi [@andrewmagliozzi](http://github.com/andrewmagliozzi)
- Daniel Collis-Puro [@djcp](http://github.com/djcp)
- Seth Woodworth [@sethwoodworth](http://github.com/sethwoodworth)
- Ayse Gursoy [@gursoy](http://github.com/gursoy)
- Jacob Hilker [@jhilker](http://github.com/jhilker)
- Ben Silverman [@blms](http://github.com/blms)
- Peggy Wang [@pegolegoeggo](http://github.com/pegolegoeggo)
- Lizao Wang [@LizaoWang](http://github.com/LizaoWang)
- Joshua Mbogo [@mbogo-mit](http://github.com/mbogo-mit)

## License
GPL2: http://www.gnu.org/licenses/gpl-2.0.html
