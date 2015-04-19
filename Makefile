VERSION=0.1.7

all: deps fmt combined

combined:
	go install .

release: release-deps
	gox -output="build/{{.Dir}}_{{.OS}}_{{.Arch}}" .

fmt:
	go fmt ./...

deps:
	go get github.com/mailhog/MailHog-Server
	go get github.com/mailhog/MailHog-UI
	cd ../MailHog-UI; make bindata
	go get github.com/mailhog/http
	go get github.com/ian-kent/go-log/log
	go get github.com/ian-kent/envconf
	go get github.com/ian-kent/goose
	go get github.com/ian-kent/linkio
	go get github.com/jteeuwen/go-bindata/...
	go get labix.org/v2/mgo
	# added to fix travis issues
	go get code.google.com/p/go-uuid/uuid
	go get code.google.com/p/go.crypto/bcrypt

test-deps:
	go get github.com/smartystreets/goconvey

release-deps:
	go get github.com/mitchellh/gox

pull:
	git pull
	cd ../data; git pull
	cd ../http; git pull
	cd ../MailHog-Server; git pull
	cd ../MailHog-UI; git pull
	cd ../smtp; git pull
	cd ../storage; git pull

tag:
	git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../data; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../http; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../MailHog-Server; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../MailHog-UI; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../smtp; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}
	cd ../storage; git tag -a -m 'v${VERSION}' ${VERSION} && git push origin ${VERSION}

.PNONY: all combined release fmt deps test-deps release-deps
