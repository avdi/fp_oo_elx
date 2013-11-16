check: lib/exercises.ex test/exercises_test.ex
	mix test

watch:
	exec rerun -p 'fp_oo.org' $(MAKE) check

lib/exercises.ex test/exercises_test.ex: fp_oo.org
	emacs --batch --file fp_oo.org -f org-babel-tangle
