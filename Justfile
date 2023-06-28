test:
	bats *.bats

ansible-run:
	ansible -o \
		-i inventory.yml \
		-M ./ -m module-name \
		-a 'action=ping' \
		all