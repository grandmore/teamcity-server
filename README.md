Image `stuartfenton/teamcity-server`

Teamcity 9.0.2 with extra build tools `php, php5-curl, phpUnit, phing, mercurial, zip, apache ant, node, npm & grunt`

Run it with 
`sudo docker run -dt --name teamcity_server -p 8111:8111 stuartfenton/teamcity-server`

To mount a volume, open te prots and restart if it fails:

`sudo docker run -v /home-teamcity:/home-teamcity -p 8111:8111 --name="teamcity-server" --restart=always -d stuartfenton/teamcity-server`


