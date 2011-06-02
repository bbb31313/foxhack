from  subprocess import *                        
p = Popen(["netstat", "-an"], bufsize=1024,stdin=PIPE, stdout=PIPE, close_fds=True)      
(fin, fout) =  (p.stdin, p.stdout)                                                 
for i in range(10):                              
    fin.write("line" + str(i))
    fin.write('\n')
    fin.flush()
    print fout.readline(),