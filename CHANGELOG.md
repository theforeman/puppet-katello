# Change Log

## [7.1.0](https://github.com/theforeman/puppet-katello/tree/7.1.0)

[Full Changelog](https://github.com/theforeman/puppet-katello/compare/7.0.0...7.1.0)

**Merged pull requests:**

- Allow extlib 2.0 [\#220](https://github.com/theforeman/puppet-katello/pull/220) ([ekohl](https://github.com/ekohl))
- pulp: remove candlepin consumers crl [\#219](https://github.com/theforeman/puppet-katello/pull/219) ([timogoebel](https://github.com/timogoebel))
- qpidd: hostname for config cmds [\#216](https://github.com/theforeman/puppet-katello/pull/216) ([timogoebel](https://github.com/timogoebel))
- candlepin: use own certs for qpid [\#215](https://github.com/theforeman/puppet-katello/pull/215) ([timogoebel](https://github.com/timogoebel))
- Don't pass $deployment\_url to candlepin [\#214](https://github.com/theforeman/puppet-katello/pull/214) ([ekohl](https://github.com/ekohl))
- Ensure the candlepin keystore symlink [\#213](https://github.com/theforeman/puppet-katello/pull/213) ([ekohl](https://github.com/ekohl))
- Fixes \#20857 - override post\_sync\_url [\#211](https://github.com/theforeman/puppet-katello/pull/211) ([sean797](https://github.com/sean797))
- Correct qpid\_client spec [\#210](https://github.com/theforeman/puppet-katello/pull/210) ([ekohl](https://github.com/ekohl))

## [7.0.0](https://github.com/theforeman/puppet-katello/tree/7.0.0) (2017-08-30)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.1.1...7.0.0)

**Merged pull requests:**

- Refactor module [\#208](https://github.com/theforeman/puppet-katello/pull/208) ([ekohl](https://github.com/ekohl))
- Remove $qpid\_session\_unacked [\#207](https://github.com/theforeman/puppet-katello/pull/207) ([ekohl](https://github.com/ekohl))
- Bump puppet-candlepin dependency [\#206](https://github.com/theforeman/puppet-katello/pull/206) ([ehelms](https://github.com/ehelms))
- Allow puppetlabs-apache 2.0 [\#205](https://github.com/theforeman/puppet-katello/pull/205) ([ekohl](https://github.com/ekohl))
- Puppet 5 preparation fixes [\#202](https://github.com/theforeman/puppet-katello/pull/202) ([ekohl](https://github.com/ekohl))
- Refs \#19514 - Expose qpid params to user [\#200](https://github.com/theforeman/puppet-katello/pull/200) ([chris1984](https://github.com/chris1984))
- msync: Puppet 5, parallel tests, .erb templates, cleanups, facter fix [\#199](https://github.com/theforeman/puppet-katello/pull/199) ([ekohl](https://github.com/ekohl))
- Allow pulp 5.x [\#198](https://github.com/theforeman/puppet-katello/pull/198) ([ekohl](https://github.com/ekohl))
- Refs \#20021 - Restart httpd when ca changes [\#197](https://github.com/theforeman/puppet-katello/pull/197) ([sean797](https://github.com/sean797))
- Bump qpid dependency [\#196](https://github.com/theforeman/puppet-katello/pull/196) ([ehelms](https://github.com/ehelms))
- Remove crane\_data\_dir [\#193](https://github.com/theforeman/puppet-katello/pull/193) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#19667 - expose Candlepin DB setup [\#192](https://github.com/theforeman/puppet-katello/pull/192) ([mbacovsky](https://github.com/mbacovsky))
- Split apache fragments [\#191](https://github.com/theforeman/puppet-katello/pull/191) ([ekohl](https://github.com/ekohl))

## [6.1.1](https://github.com/theforeman/puppet-katello/tree/6.1.1) (2017-08-28)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.1.0...6.1.1)

**Merged pull requests:**

- fixes \#20353 - Runs apipie cache after ostree [\#201](https://github.com/theforeman/puppet-katello/pull/201) ([parthaa](https://github.com/parthaa))
- Fixes \#20518 - set pulp tasks to 2 [\#203](https://github.com/theforeman/puppet-katello/pull/203) ([chris1984](https://github.com/chris1984))

## [6.1.0](https://github.com/theforeman/puppet-katello/tree/6.1.0) (2017-04-07)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.0.3...6.1.0)

**Merged pull requests:**

- Make GPG key optional [\#187](https://github.com/theforeman/puppet-katello/pull/187) ([ehelms](https://github.com/ehelms))
- Expand ignore with generated files/directories [\#186](https://github.com/theforeman/puppet-katello/pull/186) ([ekohl](https://github.com/ekohl))
- Add optional repository management [\#185](https://github.com/theforeman/puppet-katello/pull/185) ([ekohl](https://github.com/ekohl))
- Fix dependency cycle from Candlepin exchange migration [\#184](https://github.com/theforeman/puppet-katello/pull/184) ([ehelms](https://github.com/ehelms))
- Modulesync update [\#183](https://github.com/theforeman/puppet-katello/pull/183) ([ekohl](https://github.com/ekohl))
- fixes \#19097 - remove /subscription route, change file headers [\#182](https://github.com/theforeman/puppet-katello/pull/182) ([stbenjam](https://github.com/stbenjam))
- README: Correct formatting and improve a bit [\#181](https://github.com/theforeman/puppet-katello/pull/181) ([ekohl](https://github.com/ekohl))
- Provide Candlepin with the qpid client certs [\#180](https://github.com/theforeman/puppet-katello/pull/180) ([ehelms](https://github.com/ehelms))
- Specify qpid SSL key to qpid commands [\#179](https://github.com/theforeman/puppet-katello/pull/179) ([ehelms](https://github.com/ehelms))
- Modulesync update [\#178](https://github.com/theforeman/puppet-katello/pull/178) ([ekohl](https://github.com/ekohl))
- Switch to using qpid bind [\#177](https://github.com/theforeman/puppet-katello/pull/177) ([ehelms](https://github.com/ehelms))
- Fixes \#18812 - Add exec to delete unfiltered queue [\#175](https://github.com/theforeman/puppet-katello/pull/175) ([chris1984](https://github.com/chris1984))
- pulp: enable katello [\#173](https://github.com/theforeman/puppet-katello/pull/173) ([timogoebel](https://github.com/timogoebel))
- refresh services when certs change [\#172](https://github.com/theforeman/puppet-katello/pull/172) ([timogoebel](https://github.com/timogoebel))
- Fixes \#16256 - only use SSLUsername for /pulp/api [\#169](https://github.com/theforeman/puppet-katello/pull/169) ([jlsherrill](https://github.com/jlsherrill))
- Refs \#18812 - Update bindings on event queue [\#168](https://github.com/theforeman/puppet-katello/pull/168) ([chris1984](https://github.com/chris1984))

## [6.0.3](https://github.com/theforeman/puppet-katello/tree/6.0.3) (2017-03-06)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.0.2...6.0.3)

**Merged pull requests:**

- Update modulesync config [\#167](https://github.com/theforeman/puppet-katello/pull/167) ([ekohl](https://github.com/ekohl))
- Verify pulp CA against server CA [\#166](https://github.com/theforeman/puppet-katello/pull/166) ([stbenjam](https://github.com/stbenjam))
- refs \#16253 - pulp\_max\_speed should be optional [\#165](https://github.com/theforeman/puppet-katello/pull/165) ([stbenjam](https://github.com/stbenjam))
- Refs \#16253 - Add max speed var to Katello [\#162](https://github.com/theforeman/puppet-katello/pull/162) ([chris1984](https://github.com/chris1984))

## [6.0.2](https://github.com/theforeman/puppet-katello/tree/6.0.2) (2017-01-26)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.0.1...6.0.2)

**Merged pull requests:**

- make proxy params optional [\#164](https://github.com/theforeman/puppet-katello/pull/164) ([jlsherrill](https://github.com/jlsherrill))

## [6.0.1](https://github.com/theforeman/puppet-katello/tree/6.0.1) (2017-01-24)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/6.0.0...6.0.1)

**Merged pull requests:**

- fixes \#18144 - set /etc/crane.conf data\_dir [\#163](https://github.com/theforeman/puppet-katello/pull/163) ([thomasmckay](https://github.com/thomasmckay))
- Change existing Kafo type definitions to Puppet 4 types [\#160](https://github.com/theforeman/puppet-katello/pull/160) ([stbenjam](https://github.com/stbenjam))

## [6.0.0](https://github.com/theforeman/puppet-katello/tree/6.0.0) (2016-11-30)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/5.1.1...6.0.0)

**Merged pull requests:**

- Optimize tests [\#159](https://github.com/theforeman/puppet-katello/pull/159) ([ekohl](https://github.com/ekohl))
- module sync update [\#158](https://github.com/theforeman/puppet-katello/pull/158) ([jlsherrill](https://github.com/jlsherrill))
- Remove dependency cycle caused by addition of foreman-service anchor [\#156](https://github.com/theforeman/puppet-katello/pull/156) ([ehelms](https://github.com/ehelms))
- Fixes \#17400: Configure CA cert for Pulp communication [\#155](https://github.com/theforeman/puppet-katello/pull/155) ([ehelms](https://github.com/ehelms))
- Fixes \#17380: Configure ca\_cert\_file for Candlepin communication [\#154](https://github.com/theforeman/puppet-katello/pull/154) ([ehelms](https://github.com/ehelms))
- Crane moved back to capsule for now [\#153](https://github.com/theforeman/puppet-katello/pull/153) ([stbenjam](https://github.com/stbenjam))
- Fixes \#17298 - Add max tasks per Pulp worker [\#151](https://github.com/theforeman/puppet-katello/pull/151) ([mbacovsky](https://github.com/mbacovsky))
- Enable crane in Katello too [\#150](https://github.com/theforeman/puppet-katello/pull/150) ([stbenjam](https://github.com/stbenjam))
- Modulesync, bump major for 1.8.7/el6 drop [\#149](https://github.com/theforeman/puppet-katello/pull/149) ([stbenjam](https://github.com/stbenjam))
- Modulesync [\#147](https://github.com/theforeman/puppet-katello/pull/147) ([stbenjam](https://github.com/stbenjam))
- Modulesync [\#146](https://github.com/theforeman/puppet-katello/pull/146) ([stbenjam](https://github.com/stbenjam))
- Document package\_names as an array [\#145](https://github.com/theforeman/puppet-katello/pull/145) ([stbenjam](https://github.com/stbenjam))
- Modulesync: rspec-puppet-facts updates [\#144](https://github.com/theforeman/puppet-katello/pull/144) ([stbenjam](https://github.com/stbenjam))
- Remove keepalive settings [\#141](https://github.com/theforeman/puppet-katello/pull/141) ([ekohl](https://github.com/ekohl))
- Improve ownership and remove unused code [\#140](https://github.com/theforeman/puppet-katello/pull/140) ([ekohl](https://github.com/ekohl))
- refs \#10283 - mark parameters advanced [\#139](https://github.com/theforeman/puppet-katello/pull/139) ([stbenjam](https://github.com/stbenjam))
- refs \#11737 - connect to localhost for qpid [\#79](https://github.com/theforeman/puppet-katello/pull/79) ([stbenjam](https://github.com/stbenjam))

## [5.1.1](https://github.com/theforeman/puppet-katello/tree/5.1.1) (2016-09-12)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/5.1.0...5.1.1)

## [5.1.0](https://github.com/theforeman/puppet-katello/tree/5.1.0) (2016-09-12)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/5.0.1...5.1.0)

**Merged pull requests:**

- Fix breaking unit tests [\#143](https://github.com/theforeman/puppet-katello/pull/143) ([ehelms](https://github.com/ehelms))
- Modulesync update [\#142](https://github.com/theforeman/puppet-katello/pull/142) ([ehelms](https://github.com/ehelms))
- Wrap `PassengerEnabled` in module check [\#137](https://github.com/theforeman/puppet-katello/pull/137) ([beav](https://github.com/beav))
- Fixes \#15841 - limit pulp puppet wsgi procs [\#136](https://github.com/theforeman/puppet-katello/pull/136) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#15727 - Not receiving candlepin messages [\#135](https://github.com/theforeman/puppet-katello/pull/135) ([johnpmitsch](https://github.com/johnpmitsch))
- Modulesync: pin json\_pure [\#134](https://github.com/theforeman/puppet-katello/pull/134) ([stbenjam](https://github.com/stbenjam))
- Pin extlib since they dropped 1.8.7 support [\#133](https://github.com/theforeman/puppet-katello/pull/133) ([stbenjam](https://github.com/stbenjam))
- refs \#15217 - puppet 4 support [\#132](https://github.com/theforeman/puppet-katello/pull/132) ([stbenjam](https://github.com/stbenjam))

## [5.0.1](https://github.com/theforeman/puppet-katello/tree/5.0.1) (2016-06-10)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/5.0.0...5.0.1)

**Merged pull requests:**

- Relax puppet-certs minimum requirement [\#131](https://github.com/theforeman/puppet-katello/pull/131) ([ehelms](https://github.com/ehelms))
- Remove unused $rhsm\_url variable [\#127](https://github.com/theforeman/puppet-katello/pull/127) ([ekohl](https://github.com/ekohl))

## [5.0.0](https://github.com/theforeman/puppet-katello/tree/5.0.0) (2016-06-08)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/4.0.0...5.0.0)

**Merged pull requests:**

- refs \#15326 - revert mongo auth [\#130](https://github.com/theforeman/puppet-katello/pull/130) ([stbenjam](https://github.com/stbenjam))

## [4.0.0](https://github.com/theforeman/puppet-katello/tree/4.0.0) (2016-05-27)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/3.1.0...4.0.0)

**Merged pull requests:**

- Fixes \#15170 - Moving timeout to a large enough value [\#129](https://github.com/theforeman/puppet-katello/pull/129) ([mccun934](https://github.com/mccun934))
- Fixes \#13682 - turn on repo auth [\#128](https://github.com/theforeman/puppet-katello/pull/128) ([jlsherrill](https://github.com/jlsherrill))
- Remove 'tomcat' param [\#125](https://github.com/theforeman/puppet-katello/pull/125) ([kmcfate](https://github.com/kmcfate))
- Refs \#14858 - removes gutterball [\#124](https://github.com/theforeman/puppet-katello/pull/124) ([cfouant](https://github.com/cfouant))

## [3.1.0](https://github.com/theforeman/puppet-katello/tree/3.1.0) (2016-05-18)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/3.0.0...3.1.0)

**Merged pull requests:**

- fixes \#15058 - enable mongo auth [\#126](https://github.com/theforeman/puppet-katello/pull/126) ([stbenjam](https://github.com/stbenjam))
- Refs \#14698 - create default directory for repo exports [\#123](https://github.com/theforeman/puppet-katello/pull/123) ([beav](https://github.com/beav))
- Add paths for puppet-lint docs check [\#122](https://github.com/theforeman/puppet-katello/pull/122) ([stbenjam](https://github.com/stbenjam))
- Fixes \#14617 - communicate with candlepin over fqdn [\#121](https://github.com/theforeman/puppet-katello/pull/121) ([jlsherrill](https://github.com/jlsherrill))
- Simplify variables in katello::qpid [\#119](https://github.com/theforeman/puppet-katello/pull/119) ([ekohl](https://github.com/ekohl))
- Fixes \#14324 - Restarts foreman-tasks and httpd on ostree enable [\#118](https://github.com/theforeman/puppet-katello/pull/118) ([parthaa](https://github.com/parthaa))
- Modulesync [\#117](https://github.com/theforeman/puppet-katello/pull/117) ([stbenjam](https://github.com/stbenjam))
- Fixes \#13199 - change pulp\_parent to qpid\_client [\#116](https://github.com/theforeman/puppet-katello/pull/116) ([johnpmitsch](https://github.com/johnpmitsch))
- Fixes 13199 - remove pulp-nodes packages as dependency [\#115](https://github.com/theforeman/puppet-katello/pull/115) ([johnpmitsch](https://github.com/johnpmitsch))
- Fixes \#14081 - disable repo auth to work around uber cert issue [\#114](https://github.com/theforeman/puppet-katello/pull/114) ([jlsherrill](https://github.com/jlsherrill))

## [3.0.0](https://github.com/theforeman/puppet-katello/tree/3.0.0) (2016-02-24)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/2.0.2...3.0.0)

**Merged pull requests:**

- Remove concat\_native [\#113](https://github.com/theforeman/puppet-katello/pull/113) ([ehelms](https://github.com/ehelms))
- fixes \#13451 - enables squid management in pulp [\#112](https://github.com/theforeman/puppet-katello/pull/112) ([daviddavis](https://github.com/daviddavis))
- ignore MaxKeepAliveRequests if not set [\#111](https://github.com/theforeman/puppet-katello/pull/111) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#13605 - Configure keep alive for 443 virtual host [\#110](https://github.com/theforeman/puppet-katello/pull/110) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#13625 - Install Ostree packages on enablement [\#108](https://github.com/theforeman/puppet-katello/pull/108) ([parthaa](https://github.com/parthaa))
- Refs \#13658 - remove cycle from puppet graph [\#106](https://github.com/theforeman/puppet-katello/pull/106) ([beav](https://github.com/beav))
- enable repo auth for pulp [\#105](https://github.com/theforeman/puppet-katello/pull/105) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#13658 - pulp\_client\_key and pulp\_client\_cert not being set cor… [\#104](https://github.com/theforeman/puppet-katello/pull/104) ([johnpmitsch](https://github.com/johnpmitsch))
- Bump requirement on puppet-pulp to 3.X [\#103](https://github.com/theforeman/puppet-katello/pull/103) ([ehelms](https://github.com/ehelms))
- do not set ca\_cert on pulp module [\#102](https://github.com/theforeman/puppet-katello/pull/102) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#13503 - Updating post sync url [\#101](https://github.com/theforeman/puppet-katello/pull/101) ([parthaa](https://github.com/parthaa))
- Refs \#13607 - Removed pulp.conf [\#100](https://github.com/theforeman/puppet-katello/pull/100) ([parthaa](https://github.com/parthaa))
- bump candlepin requirement [\#99](https://github.com/theforeman/puppet-katello/pull/99) ([jlsherrill](https://github.com/jlsherrill))
- Refs \#13431 - Apache changes for pulp 2.8 [\#98](https://github.com/theforeman/puppet-katello/pull/98) ([parthaa](https://github.com/parthaa))
- add truststore\_password for gutterball [\#97](https://github.com/theforeman/puppet-katello/pull/97) ([cristifalcas](https://github.com/cristifalcas))
- Remove unused katello.erb [\#96](https://github.com/theforeman/puppet-katello/pull/96) ([ekohl](https://github.com/ekohl))
- Fixes \#13189 - allows for certificate authentication of capsules [\#95](https://github.com/theforeman/puppet-katello/pull/95) ([cfouant](https://github.com/cfouant))
- add a truststore\_password parameter for candlepin [\#94](https://github.com/theforeman/puppet-katello/pull/94) ([cristifalcas](https://github.com/cristifalcas))

## [2.0.2](https://github.com/theforeman/puppet-katello/tree/2.0.2) (2015-11-20)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/2.0.1...2.0.2)

**Merged pull requests:**

- Fixes \#12448 - migrate to pulp 2.0 module [\#93](https://github.com/theforeman/puppet-katello/pull/93) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#12475: Configure Candlepin AMQP since it is off by default [\#92](https://github.com/theforeman/puppet-katello/pull/92) ([ehelms](https://github.com/ehelms))
- Fixes \#10291 - removes elasticsearch [\#85](https://github.com/theforeman/puppet-katello/pull/85) ([cfouant](https://github.com/cfouant))

## [2.0.1](https://github.com/theforeman/puppet-katello/tree/2.0.1) (2015-10-29)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/2.0.0...2.0.1)

**Merged pull requests:**

- \[messaging\] disable authentication [\#91](https://github.com/theforeman/puppet-katello/pull/91) ([bbuckingham](https://github.com/bbuckingham))

## [2.0.0](https://github.com/theforeman/puppet-katello/tree/2.0.0) (2015-10-14)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/1.0.2...2.0.0)

**Merged pull requests:**

- Use cache\_data and random\_password from extlib [\#89](https://github.com/theforeman/puppet-katello/pull/89) ([ehelms](https://github.com/ehelms))
- Fixes \#12110 - updating puppet-pulp to use is\_parent =\> true param [\#88](https://github.com/theforeman/puppet-katello/pull/88) ([johnpmitsch](https://github.com/johnpmitsch))
- Fixes \#12062 - exposing pulp num\_workers as parameter [\#87](https://github.com/theforeman/puppet-katello/pull/87) ([jlsherrill](https://github.com/jlsherrill))
- Refs \#11998 - manage plugin httpd configs for pulp [\#86](https://github.com/theforeman/puppet-katello/pull/86) ([jlsherrill](https://github.com/jlsherrill))
- Don't pass ca cert/key to Pulp [\#84](https://github.com/theforeman/puppet-katello/pull/84) ([ehelms](https://github.com/ehelms))
- Update Candlepin config [\#83](https://github.com/theforeman/puppet-katello/pull/83) ([ehelms](https://github.com/ehelms))
- Refs \#10621: Update configuration file for migration to SETTINGS [\#74](https://github.com/theforeman/puppet-katello/pull/74) ([ehelms](https://github.com/ehelms))

## [1.0.2](https://github.com/theforeman/puppet-katello/tree/1.0.2) (2015-09-10)
[Full Changelog](https://github.com/theforeman/puppet-katello/compare/1.0.0...1.0.2)

**Merged pull requests:**

- Cherry picks for puppet-katello 1.0.2 [\#81](https://github.com/theforeman/puppet-katello/pull/81) ([stbenjam](https://github.com/stbenjam))
- Bump to 2.0.0 [\#80](https://github.com/theforeman/puppet-katello/pull/80) ([stbenjam](https://github.com/stbenjam))
- Enable Pulp content types supported by Katello [\#78](https://github.com/theforeman/puppet-katello/pull/78) ([ehelms](https://github.com/ehelms))
- Fixes \#11609: Update to use Pulp module 1.0 [\#77](https://github.com/theforeman/puppet-katello/pull/77) ([ehelms](https://github.com/ehelms))
- Update package to tfm- prefix to support new Foreman SCL. [\#76](https://github.com/theforeman/puppet-katello/pull/76) ([ehelms](https://github.com/ehelms))
- fixes \#11326 - fixes pulp isos from being inaccessible via httpd [\#75](https://github.com/theforeman/puppet-katello/pull/75) ([cfouant](https://github.com/cfouant))

## [1.0.0](https://github.com/theforeman/puppet-katello/tree/1.0.0) (2015-07-20)
**Merged pull requests:**

- Prepare puppet-katello for release [\#72](https://github.com/theforeman/puppet-katello/pull/72) ([stbenjam](https://github.com/stbenjam))
- Fixes \#10885 - Allow customizing mongodb path [\#71](https://github.com/theforeman/puppet-katello/pull/71) ([adamruzicka](https://github.com/adamruzicka))
- Updates from modulesync [\#70](https://github.com/theforeman/puppet-katello/pull/70) ([ehelms](https://github.com/ehelms))
- Adding support for Scientific Linux [\#69](https://github.com/theforeman/puppet-katello/pull/69) ([ehelms](https://github.com/ehelms))
- Refs \#8585: Fix broken Pulp API. [\#67](https://github.com/theforeman/puppet-katello/pull/67) ([ehelms](https://github.com/ehelms))
- Pin rspec on ruby 1.8.7 [\#66](https://github.com/theforeman/puppet-katello/pull/66) ([stbenjam](https://github.com/stbenjam))
- Refs \#7780: Move crane setup to capsule. [\#65](https://github.com/theforeman/puppet-katello/pull/65) ([ehelms](https://github.com/ehelms))
- Refs 9207 [\#64](https://github.com/theforeman/puppet-katello/pull/64) ([ehelms](https://github.com/ehelms))
- Remove Puppet 2.7 support from testing. [\#63](https://github.com/theforeman/puppet-katello/pull/63) ([ehelms](https://github.com/ehelms))
- Fixes \#9483 - notify the services after gutterball configuration changes [\#62](https://github.com/theforeman/puppet-katello/pull/62) ([iNecas](https://github.com/iNecas))
- Fixes \#7716: Restart foreman-tasks when katello.yml changes. [\#61](https://github.com/theforeman/puppet-katello/pull/61) ([ehelms](https://github.com/ehelms))
- Fixes \#9466 - gutterball.conf missing gutterball.amqp.connect [\#60](https://github.com/theforeman/puppet-katello/pull/60) ([dustints](https://github.com/dustints))
- refs \#9060 - configure qpid::client with params [\#59](https://github.com/theforeman/puppet-katello/pull/59) ([stbenjam](https://github.com/stbenjam))
- Ref \#9134 - gb plugin sets configs for foreman-gutterball [\#58](https://github.com/theforeman/puppet-katello/pull/58) ([dustints](https://github.com/dustints))
- Ref \#9055 - make packages depended on, a configurable parameter [\#56](https://github.com/theforeman/puppet-katello/pull/56) ([dustints](https://github.com/dustints))
- Fixes \#8849 - installs foreman\_gutterball [\#54](https://github.com/theforeman/puppet-katello/pull/54) ([dustints](https://github.com/dustints))
- Refs \#8756: Remove consumer cert generation Katello module in favor of c... [\#53](https://github.com/theforeman/puppet-katello/pull/53) ([ehelms](https://github.com/ehelms))
- Ref \#8548 - optionally configure gutterball [\#52](https://github.com/theforeman/puppet-katello/pull/52) ([dustints](https://github.com/dustints))
- Fixes \#8444 - Expose cdn\_ssl\_version as an installer [\#51](https://github.com/theforeman/puppet-katello/pull/51) ([parthaa](https://github.com/parthaa))
- Fixes \#8585: Remove unused configuration and unneeded functions. [\#50](https://github.com/theforeman/puppet-katello/pull/50) ([ehelms](https://github.com/ehelms))
- Added recognition of Scientific Linux [\#48](https://github.com/theforeman/puppet-katello/pull/48) ([jcpunk](https://github.com/jcpunk))
- fixes \#8345 - explicitly install katello package [\#47](https://github.com/theforeman/puppet-katello/pull/47) ([stbenjam](https://github.com/stbenjam))
- Refs \#8270: Let defaults be defined by params instead of documentation. [\#46](https://github.com/theforeman/puppet-katello/pull/46) ([ehelms](https://github.com/ehelms))
- Fixes \#7802 - ensures qpidd group present before adding user to group [\#45](https://github.com/theforeman/puppet-katello/pull/45) ([dustints](https://github.com/dustints))
- Move all OS-dependent config to params.pp [\#44](https://github.com/theforeman/puppet-katello/pull/44) ([ekohl](https://github.com/ekohl))
- Refs \#7633: Fix bad version of theforeman-concat\_native in metadata.json [\#43](https://github.com/theforeman/puppet-katello/pull/43) ([bbuckingham](https://github.com/bbuckingham))
- Refs \#7633: Fix bad version of katello-elasticsearch in metadata.json [\#42](https://github.com/theforeman/puppet-katello/pull/42) ([ehelms](https://github.com/ehelms))
- Fixes \#7882 Added support for OracleLinux [\#41](https://github.com/theforeman/puppet-katello/pull/41) ([soumentrivedi](https://github.com/soumentrivedi))
- refs \#7779 - Updating to add support for pulp crane [\#39](https://github.com/theforeman/puppet-katello/pull/39) ([bbuckingham](https://github.com/bbuckingham))
- Fixes \#7745 - allow client cert header through [\#38](https://github.com/theforeman/puppet-katello/pull/38) ([dustints](https://github.com/dustints))
- Fixes \#7802 - allow user to be passed into qpid module [\#37](https://github.com/theforeman/puppet-katello/pull/37) ([dustints](https://github.com/dustints))
- Refs \#6736: Updates to standard layout and adds basic tests. [\#36](https://github.com/theforeman/puppet-katello/pull/36) ([ehelms](https://github.com/ehelms))
- Refs 6297 - use foreman-tasks instead of delayed jobs [\#35](https://github.com/theforeman/puppet-katello/pull/35) ([iNecas](https://github.com/iNecas))
- Refs \#6806: Remove references to passencrypt. [\#34](https://github.com/theforeman/puppet-katello/pull/34) ([ehelms](https://github.com/ehelms))
- Fixes \#6544 - q to receive candlepin events [\#33](https://github.com/theforeman/puppet-katello/pull/33) ([dustints](https://github.com/dustints))
- Break dependency cycle between Candlepin and Qpid. [\#31](https://github.com/theforeman/puppet-katello/pull/31) ([awood](https://github.com/awood))
- Fixes \#4650 - consumer cert rpm name in config [\#30](https://github.com/theforeman/puppet-katello/pull/30) ([dustints](https://github.com/dustints))
- Fixes \#6141 - support httpd-2.4 on RHEL 7 [\#29](https://github.com/theforeman/puppet-katello/pull/29) ([jmontleon](https://github.com/jmontleon))
- Refs \#6126: Change RHSM API to /rhsm. [\#28](https://github.com/theforeman/puppet-katello/pull/28) ([ehelms](https://github.com/ehelms))
- Fixes \#5639: Adds proxy options for Katello and CDN settings. [\#27](https://github.com/theforeman/puppet-katello/pull/27) ([ehelms](https://github.com/ehelms))
- Refs \#5815 - remove the node registration feature [\#26](https://github.com/theforeman/puppet-katello/pull/26) ([iNecas](https://github.com/iNecas))
- fixes \#5486  prefix and candlepin url incorrect for rhsm template on dev... [\#25](https://github.com/theforeman/puppet-katello/pull/25) ([dustints](https://github.com/dustints))
- Refs \#5423 - minor changes to support capsule installer [\#23](https://github.com/theforeman/puppet-katello/pull/23) ([iNecas](https://github.com/iNecas))
- Fixes \#5020 - use fqdn in the messaging url [\#21](https://github.com/theforeman/puppet-katello/pull/21) ([iNecas](https://github.com/iNecas))
- fixes \#4988 - missing token in post\_sync\_url [\#20](https://github.com/theforeman/puppet-katello/pull/20) ([jlsherrill](https://github.com/jlsherrill))
- Fixes \#4839 - make sure http is running before the seed script [\#19](https://github.com/theforeman/puppet-katello/pull/19) ([iNecas](https://github.com/iNecas))
- Adding missing default params. [\#18](https://github.com/theforeman/puppet-katello/pull/18) ([ehelms](https://github.com/ehelms))
- Adding previously used header setting and older RHSM configuration [\#17](https://github.com/theforeman/puppet-katello/pull/17) ([ehelms](https://github.com/ehelms))
- Adding ability to configure whether passenger is being used to make [\#16](https://github.com/theforeman/puppet-katello/pull/16) ([ehelms](https://github.com/ehelms))
- Removing unused templates, references to /usr/share/katello and adding [\#15](https://github.com/theforeman/puppet-katello/pull/15) ([ehelms](https://github.com/ehelms))
- adding post\_sync\_url secret token [\#14](https://github.com/theforeman/puppet-katello/pull/14) ([jlsherrill](https://github.com/jlsherrill))
- Make sure the foreman certs are configured properly [\#13](https://github.com/theforeman/puppet-katello/pull/13) ([iNecas](https://github.com/iNecas))
- Adding Candlepin certs setup removed from the Candlepin module itself. [\#12](https://github.com/theforeman/puppet-katello/pull/12) ([ehelms](https://github.com/ehelms))
- adding apache user to the foreman group [\#11](https://github.com/theforeman/puppet-katello/pull/11) ([jlsherrill](https://github.com/jlsherrill))
- adding vhost configuration for foreman [\#10](https://github.com/theforeman/puppet-katello/pull/10) ([jlsherrill](https://github.com/jlsherrill))
- Cleanup and updates to account for changes in the Candlepin, Pulp and Ce... [\#9](https://github.com/theforeman/puppet-katello/pull/9) ([ehelms](https://github.com/ehelms))
- DO NOT MERGE adding cert key, ca, and crl to pulp [\#8](https://github.com/theforeman/puppet-katello/pull/8) ([jlsherrill](https://github.com/jlsherrill))
- Katello-jobs for dynflow integration needs to be running before seed [\#6](https://github.com/theforeman/puppet-katello/pull/6) ([iNecas](https://github.com/iNecas))
- Removing Katello seed and migrate commands since we get those from Forem... [\#5](https://github.com/theforeman/puppet-katello/pull/5) ([ehelms](https://github.com/ehelms))
- Updates for parameterization and certs updates. [\#4](https://github.com/theforeman/puppet-katello/pull/4) ([ehelms](https://github.com/ehelms))
- Katello certs work [\#3](https://github.com/theforeman/puppet-katello/pull/3) ([iNecas](https://github.com/iNecas))
- Fixing linting issues. [\#2](https://github.com/theforeman/puppet-katello/pull/2) ([ehelms](https://github.com/ehelms))
- adding back service puppet class and removing old katello service [\#1](https://github.com/theforeman/puppet-katello/pull/1) ([jlsherrill](https://github.com/jlsherrill))



\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*
