FROM ubuntu:20.04
ENV USER ml855063
# bc newer ubuntu asks for timezone info
ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y apache2
WORKDIR /etc/apache2

RUN a2enmod userdir
RUN a2enmod autoindex
RUN a2enmod alias

# create dir for each site, copy index.html in, setup vhost files
RUN mkdir /var/www/html/site1
RUN mkdir /var/www/html/site2
RUN mkdir /var/www/html/site3
COPY assets /var/www/html/assets
COPY site1.html /var/www/html/site1
COPY site2.html /var/www/html/site2
COPY site3.html /var/www/html/site3
COPY site1.conf /etc/apache2/sites-available
COPY site2.conf /etc/apache2/sites-available
COPY site3.conf /etc/apache2/sites-available

# create user and public_html dir, copy files
RUN useradd -ms /bin/bash $USER
RUN mkdir /home/$USER/public_html 
COPY $USER.html /home/$USER/public_html/index.html
COPY $USER/assets /home/$USER/public_html/assets
RUN chown -R $USER.$USER /home/$USER

LABEL maintainer="monica.luong.234@my.csun.edu"
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
