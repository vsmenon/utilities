#!/usr/bin/python
import os, fnmatch
import optparse
import sys

def findReplace(directory, find, replace, filePattern):
    for path, dirs, files in os.walk(os.path.abspath(directory)):
        for filename in fnmatch.filter(files, filePattern):
            filepath = os.path.join(path, filename)
            with open(filepath) as f:
                s = f.read()
            s = s.replace(find, replace)
            with open(filepath, "w") as f:
                f.write(s)

def main():
  parser = optparse.OptionParser()
  parser.add_option('-f', '--find', dest='find',
                    action='store', type='string',
                    help='string to find')
  parser.add_option('-r', '--replace', dest='replace',
                    action='store', type='string',
                    help='string to replace with')
  parser.add_option('-d', '--dir', dest='dir',
                    action='store', type='string',
                    help='directory')
  parser.add_option('-p', '--pattern', dest='pattern',
                    action='store', type='string',
                    help='file pattern')

  (options, args) = parser.parse_args()
  findReplace(options.dir, options.find, options.replace, options.pattern)
  return 0


if __name__ == '__main__':
  sys.exit(main())
