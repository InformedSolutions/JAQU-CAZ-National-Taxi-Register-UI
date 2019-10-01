build:
	docker build -t pa11y-ci .

test:
	docker run -it -v /vagrant/pa11y/screenshots:/screenshots -e BASE_URL=http://ntr-alb-dev-253331897.eu-west-2.elb.amazonaws.com pa11y-ci
