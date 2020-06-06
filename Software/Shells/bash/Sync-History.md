# bash
## Sync History

I'm a long time `zsh` user, but for certain things at work I need to use `bash`. For the most part I don't notice much difference, except for how the shells handle command history.

By default, `bash` doesn't update your command history until you exit the shell. This can be frustrating if you have many shells open, and don't remember where you input a particular command you're looking for.

A common solution is to [write and re-load history with every command](https://unix.stackexchange.com/a/18443). This effectively creates one unified history across all shells. 

However, the behavior I was looking for was a little different. I wanted to preserve the exact history for each running shell, but I wanted _new_ shells to integrate all previous history.

The solution was relatively simple. I added the following to my `.bashrc`:

```
HISTCONTROL=ignoredups:erasedups
shopt -s histappend

PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
```

Notice that I don't `export PROMPT_COMMAND`. Apparently the `export` is not necessary and actually an error in some cases. I also use [liquidprompt](https://github.com/nojhan/liquidprompt), and when `PROMPT_COMMAND` was exported, new shells would sometimes hang. I found some clues [here](https://github.com/nojhan/liquidprompt/issues/352). I didn't dig into _why_ exporting `PROMPT_COMMAND` caused problems for me - I was just happy to get it working.

Now I have the behavior I was wanted. After every command, history is appended but not reloaded. If I did want to bring my full history into the current shell, I can type `history -c; history -r`. I added a little alias for this:

```
alias reload-history='history -c; history -r'
```