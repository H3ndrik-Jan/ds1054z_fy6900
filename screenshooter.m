h = DS1054Z('192.168.178.129');
while true
    img = h.ScreenShot();
    cla reset;
    imshow(img);
    clear img;
end