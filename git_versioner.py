#!/usr/bin/env python
import subprocess

def find_version_number():
    git_output = subprocess.check_output(['git','describe','--tags','--dirty'])
    elements = git_output.rstrip().split('-')
    tag_components = [elements[0]]
    if len(elements)>1:
        if elements[1].isdigit():
            tag_components.append('dev'+elements[1])
        if 'dirty' in elements:
            tag_components.append('dirty')
            

    return '.'.join(tag_components)

if __name__=='__main__':
    print find_version_number()
