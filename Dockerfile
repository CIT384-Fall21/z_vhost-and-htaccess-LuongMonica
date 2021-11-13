FROM ubuntu:20.04
ENV USER ml855063
# bc newer ubuntu asks for timezone info
ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update && apt-get install -y apache2 apache2-utils curl
WORKDIR /etc/apache2

RUN a2enmod userdir
RUN a2enmod autoindex
RUN a2enmod alias

# create dir for each site, copy index.html in, setup vhost files
RUN mkdir /var/www/html/site1
RUN mkdir /var/www/html/site2
RUN mkdir /var/www/html/site3
COPY assets /var/www/html/assets
COPY site1.html /var/www/html/site1/index.html
COPY site2.html /var/www/html/site2/index.html
COPY site3.html /var/www/html/site3/index.html
COPY vhosts/site1.conf /etc/apache2/sites-available
COPY vhosts/site2.conf /etc/apache2/sites-available
COPY vhosts/site3.conf /etc/apache2/sites-available

# create user and public_html dir, copy files
RUN useradd -ms /bin/bash $USER
RUN mkdir -p /home/$USER/public_html/Dev
COPY $USER/public_html/index.html /home/$USER/public_html
COPY $USER/public_html/Dev/index.html /home/$USER/public_html/Dev
COPY $USER/public_html/Dev/.htaccess /home/$USER/public_html/Dev
RUN htpasswd -cb /home/${USER}/.htpasswd ${USER} "passwd"
RUN chown -R $USER.$USER /home/$USER

# enable the sites
RUN a2ensite site1.conf
RUN a2ensite site2.conf
RUN a2ensite site3.conf
# RUN a2disite 000-default.conf

LABEL maintainer="monica.luong.234@my.csun.edu"
EXPOSE 80
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
