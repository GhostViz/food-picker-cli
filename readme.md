# Food Picker CLI

This is a food picker command line interface using the Yelp Fusion API. This is written in Ruby and should be compatible with Ruby 2.2 and higher.
I used the yelp-fusion repo as a base for this so I could learn some  of the basics of the Yelp Fusion API. (https://github.com/Yelp/yelp-fusion.git)

## Setup

Clone the repo:

```
$ git clone git@github.com:GhostViz/food-picker-cli.git
```

Go into the directory:

```
$ cd food-picker-cli
```

Install the dependences:

```
$ bundle
```

Open up the `app.rb` file and put your client_id and client_secret from the [manage app page](https://www.yelp.com/developers/v3/manage_app)

```
# Place holders for Yelp Fusion's OAuth 2.0 credentials. Grab them
# from https://www.yelp.com/developers/v3/manage_app
CLIENT_ID = <YOUR_CLIENT_ID>
CLIENT_SECRET = <YOUR_CLIENT_SECRET>
```

## Usage

Once you're all setup, you should be able to run the script directly from the command line:
```
$ ruby app.rb
```
The above will run using the defaults term=food, location=75240, and limit=10

To specify your own location, term and limit you can use the following parameters

```
$ ruby app.rb --term="TERM" --location="LOCATION" --limit="NUMBER"
```

``` --term ``` is the keyword you are searching for. Lunch, Breakfast, Mexican, Chinese, etc

``` --location ``` is either your city, state or zipcode

``` --limit ``` is the number of results you'd like your random selection to be picked from
