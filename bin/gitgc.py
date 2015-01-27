#!/usr/bin/python
import subprocess
import sys

def run(command):
    try:
        return subprocess.check_output(command, shell=True)
    except:
        return ""

def main():
    branches = run("git branch").split()
    branches.remove('*')
    branches = set(branches)
    print 'All: ' + str(branches)

    allremotes = run("git branch -r").split('\n')
    remotes = set([])
    for remote in allremotes:
        if '->' in remote:
            remotes.add(remote.split()[2].split('/')[1])
    print 'Tracking: ' + str(remotes)
    
    rietvelds = run("git config --get-regexp branch.*.rietveldissue").split('\n')
    current = set([])
    for rietveld in rietvelds:
        if 'rietveldissue' in rietveld:
            current.add(rietveld.split('.')[1])
    print "Current: " + str(current)

    delete = branches - remotes - current
    cleanup = None
    if delete:
        cleanup = "git branch -D " + " ".join(delete)
    print cleanup
    
    return 0
    
if __name__ == '__main__':
  sys.exit(main())
