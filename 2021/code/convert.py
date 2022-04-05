import sys
import numpy as np
import scipy.io as io

def is_not_number(s):
    try:
        float(s)
        return False
    except ValueError:
        return True

# f = open('test_1trace_small_small2.txt','r')
input_name = sys.argv[1]
f = open(input_name,'r')

text = f.read()
f.close()
lines = text.split('\n')

data = {}
for line in lines:
    items = line.split('\t')
    label = ''
    for ind, item in enumerate(items):
        if is_not_number(item):
            label += item
        else:
            break
    if label=='':
        continue
    label = label.replace(' ','')
    if len(items[ind:])==1:
        values = np.array([])
    else:
        values = np.array([float(val) for val in items[ind:]])
    data[label] = values
 

# io.savemat('test_data.mat',{'time':data['time']})
name = sys.argv[2]
if name[-4:]=='.mat':
    io.savemat(name,data)
elif name[-4:]=='.npy':
    np.save(name,data)
    
