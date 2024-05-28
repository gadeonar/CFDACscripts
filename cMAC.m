function M = cMAC(data1,data2)
    M = ((data1'*data2)^2)/((data1'*data1)*(data2'*data2));
end
