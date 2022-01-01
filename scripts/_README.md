# Powershell scripts

### File descriptions

#### <tt>install-application.ps1</tt>

- Called by build process for installing ``<project>.mfappx`` file 
to M-Files Vault(s) as configured in  
``install-application-user.json``
- Relevant for all configuration where ``DefineConstants``
does not contain the keyword ``DONOTDEPLOY`` in ``<project>.csproj`` file
- By default: only for configuration ``DEBUG`` but not in
``DebugWithoutDeployment`` and ``Release`` configurations

#### <tt>install-application.user.json</tt>

- User specific configuration file which will not be
committed into GIT repository
- Copy it from ``install-application.user.sample.json``
if it does not exist yet
- File description see next section

#### <tt>install-application.user.sample.json</tt>

- Sample file which can be copied to ``install-application.user.json``
for newly checked out projects where the file does not exist yet
- Content of this file will be ignored

#### <tt>update-EWERK-version.ps1</tt>

- Will be call before the build process starts
- Powershell command is called as a ``PreBuildEvent``
within the MSBuild process defined in ``<project>.csproj`` file
- Calculates version from current UTC datetime -
current timestamp at the beginning of the build process when this script will be run
- Format: ``yyMd.Hmm``

### Sample for user specific connections configuration

```json
```
 
### Sample version numbers:

<table>
  <tr style="background-color: #ccc">
    <th align="left">Build start time</th>
    <th align="left">Version</th>
  <tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>2021-05-11 09:12 UTC</tt></td>
    <td align="left"><tt>21.5.11.912</tt></td>
  <tr>
  <tr style="background-color: #ddd">
    <td align="left"><tt>2021-11-05 11:56 UTC</tt></td>
    <td align="left"><tt>21.11.5.1156</tt></td>
  <tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>2021-11-30 23:59 UTC</tt></td>
    <td align="left"><tt>21.11.30.2359</tt></td>
  <tr style="background-color: #ccc">
</table>

**Advantage:**  
Newer builds always have higher versions also if
more then one developer works on the same project
even if they work in places with different timezones
