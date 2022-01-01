<center>

![12 Days of Code logo](lib/logo.png)

Based on GitHub-Repository &nbsp; | &nbsp;
https://github.com/M-Files/TwelveDaysOfCode  
M-Files Development Challenge &nbsp; | &nbsp;
**December 13<sup>th</sup> - 24<sup>th</sup>, 2021** &nbsp; | &nbsp;
enhanced  into


**EWERK-Style-Structure** by 
**Falk Huth** ([f.huth@ewerk.com](mailto:f.huth@ewerk.com))  
[github.com/falk-huth-ewerk](https://github.com/falk-huth-ewerk) &nbsp; | &nbsp;
[www.linkedin.com/in/falk-huth](https://www.linkedin.com/in/falk-huth)  
M-Files Partner EWERK Group,
see [https://ewerk.com/innovation-hub/ecm](https://ewerk.com/innovation-hub/ecm)

</center>

---

Commercial modules for M-Files created by EWERK Group
using the documentations and developer resources
which are provided by M-Files on their following websites:

  * [developer.m-files.com](https://developer.m-files.com)
  * [community.m-files.com](https://community.m-files.com)
  * [github.com/m-files](https://github.com/m-files)
  * [www.nuget.org/profiles/M-Files](https://www.nuget.org/profiles/M-Files)

Visual Studio 2019 Proessional with .NET C# was used as main programming language.

---

<!-- Start of original "M-Files 12 Days" of Code Content -->

## Overview

Have you been looking to start building M-Files customizations, or to hone your skills?  Have some free time over the festive period?  If so then why not take a look at our 12 Days of Code M-Files Development Challenge!

The purpose of this is to have a little fun and to learn some new skills.  All levels are encouraged to participate.

Each day we will release a small task that you will be asked to implement using M-Files.  Most of these tasks are aimed at the Vault Application Framework, and all require you to write some C#.  If you've not done some of these things before then each task should take you around an hour.  If you've got lots of experience then you will obviously do them quickly, but we have some ideas for how you might want to extend the task a little.

We will be running the challenge between the 13th and 24th December.  This allows you to "complete" the challenge before the typical holiday season starts.  Remember: there's no obligation to get the challenges done on the day that they're released, so pop back whenever you have time to do another one.

---

## Rules

* You can use any appropriate technology, including external libraries.  It's your code; build it as you would normally (or would like to normally!).
* If you would like to make your code available to everyone then feel free to host it on GitHub or similar.  If you would like to keep your code to yourself then that is fine as well.
* If you don't have any development experience with M-Files then start with the Developer Portal.  We'll give you guidance to get started on each day.
* If you do have M-Files development experience then take this opportunity to try out new things.  Want to unit test approaches?  Go for it.  Want to try out the VAF Extensions library? Awesome!
* Keep things positive and constructive.  Everyone's code style and concerns are different; acknowledge and accept those.
* Some of the M-Files team will be posting example solutions each day.  If you'd like us to see what you've built then we'll monitor <a href="https://www.linkedin.com/feed/hashtag/?keywords=MFiles12DaysOfCode">LinkedIn</a> and <a href="https://twitter.com/hashtag/MFiles12DaysOfCode">Twitter</a> for the hashtag #MFiles12DaysOfCode, or post on the M-Files Developer Community!
* There are no points or prizes, unfortunately.

---

## Getting Started

To take part in the challenge you will need a few things set up:

1. You will need the latest version of M-Files installed on your computer.  You can download the <a href="https://www.m-files.com/try-m-files/">30-day trial from our website</a> if you need it.
1. You will need Visual Studio 2019 or 2022 installed (the free community edition is fine, if you qualify).  You will also need the <a href="https://marketplace.visualstudio.com/items?itemName=M-Files.MFilesVisualStudioExtensions">M-Files Visual Studio Template Package</a> installed.
    1. Note: If you are using Visual Studio 2022 then you may also need to <a href="https://dotnet.microsoft.com/download/dotnet-framework/net452">install the .NET 4.5.2 developer pack</a> so that you can create .NET 4.5 applications.
1. You will need to have the <a href="vault-backup">12 Days of Code vault</a> configured.  We will use this for the challenges.

Challenges will be released once per day, in the evening.  You can choose to undertake each challenge the day it's released, or at any time over the festive period.

---

## Tasks

*Make sure that you have all your prerequisites set up: set up your M-Files server, restore the challenge vault, and install/configure Visual Studio.  Do this before the challenge begins!*

1. **13th December:** Start off simple: Use the Vault Application Framework 2.3 Visual Studio template to create a new VAF 2.3 application.
    1. Open the PowerShell file and change the vault name to install to.  Build the application in debug mode and check the Visual Studio "Output" window to check that your application was installed to the vault with no errors.
    1.	Optional: Use nuget to add a reference to the VAF Extensions library and change the VaultApplication base class to `MFiles.VAF.Extensions.ConfigurableVaultApplicationBase<Configuration>`. 
    1.	Open the `appdef.xml` file and update the name, version, publisher, and other information that you would like to set.  Also set the Multi-Server-Mode compatible flag to true.  Rebuild and check that the changes are shown in the M-Files Admin software.
1. **14th December:** Create a shared public link when a document reaches the "Shared" state in the "Share link" workflow. Populate another property with the created link.
    1. Make sure that the object audit trail isn't affected by your code!
    1. Tip: you can only create a shared link to a checked-in version of a file; "env.ObjVer" will not be checked in.  Instead load the latest not-checked-in version of the object using GetLatestObjectVersionAndProperties and setting "allowCheckedOut" to false.
    1. Tip: by default M-Files does not allow version-specific file sharing.  When setting the FileVer for the link you will typically need to set the version number to -1.
    1. Suggested extension: set the expiry date of the link to be based on another date property.
    1. Suggested extension: send an email to someone and include the public link to the document.
1. **15th December:** Integrate a logging framework of your choice (NLog or Serilog may be good options) so that you can better control logging.  Add appropriate logging to anything you've done, and remember to use it for the next days' work!
    1. Suggested extension: expose the configuration for your logging framework in the M-Files Admin, allowing users to turn on and off logging, or alter the logging levels.
    2. Suggested extension: expose the current configuration in a VAF dashboard.
1. **16th December:** Create an asynchronous operation (task queue!) that runs once per day.  The process should request data from [this github dataset](https://api.github.com/gists) and create objects in the vault for the items that are returned.
    1. Hint: .NET 4.5 does not support TLS 1.2 out of the box; you will need to set the ServicePointManager.SecurityProtocol in the VaultApplication constructor: `System.Net.ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls11 | SecurityProtocolType.Tls12;`
    1. Hint: the user agent header is required to be set to request data from this API: `webClient.Headers.Add("User-Agent", "Vault application")`
    1. Use the ID as a unique identifier.
    1. Use the file name as the object name.
    1. Choose what data to pull through into objects; you may just choose to add the object's JSON into the description property.
    1. You may want to use the VAF Extensions for this!
    1. Consider what the appropriate transaction mode is for this operation.
    1. Suggested extension: deal with IDs that have already been imported.
    1. Suggested extension: enable the user to run the process on demand.
    1. Suggested extension: allow the user to customise the schedule that this runs on.
1. **17th December:** When a project moves into the "Project Agreed" state, generate a contract and project plan from the templates in the vault.
    1. Suggested extension: make this configurable!  Allow administrators to configure which documents should be generated when an object matches some conditions.
1. **18th December:** Stop a project being moved into the "Active" state if it does not have a signed contract.  You can use a state action, state post condition, state pre-condition, or event handler, as appropriate.
    1. Suggested extension: make this configurable!  Allow administrators to configure what logic should be used to stop an object entering different workflow states.
1. **19th December:** VAF dashboards - shown when the user selects your application within the M-Files Admin configuration area - are great places to show information about your application and its status.
    1. Create a custom dashboard that shows information about the application, your/your-company's contact details, and maybe even a logo or selfie.
    1. Optional: expose some basic statistics from the vault - how many invoices are not yet approved?  How many projects are active right now?
1. **20th December:** When an Invoice moves into the "Pending upload to finance" state, the PDF should be written to disk along with an XML file containing basic information such as the associated Purchase Order number, then the object moved to the next workflow state.  This should be done as an asynchronous operation (task queues!).
    1. Suggested extension: design a process for handling that the Invoice may be checked out so cannot be updated by the task processor.
1. **21st December:** When an employee leaves the business it is important that all of the contracts that they were managing are assigned to someone else.  When a user is marked as having left the company, find all documents where the "Contract Owner" is the leaving user, and change the owner to their "Successor".  Use the "Former employee" workflow state a trigger for this process. 
    1. Test this by marking Bob T Builder as having left, with his contracts now owned by Pilchard T Cat.
    1. This should be implemented as an asynchronous operation.
    1. Consider what the transaction mode should be for this operation.
    1. Suggested extension: Consider the performance impact of there being thousands of contracts owned by one person; use `CheckOutMultipleObjects`/`SetPropertiesOfMultipleObjects`/`CheckInMultipleObjects` to instead work with batches of objects.
    1. Suggested extension: decide on a reasonable process for handling situations where batches (or single objects) cannot be updated.
1. **22nd December:** Add [licensing](https://developer.m-files.com/Frameworks/Vault-Application-Framework/Licensing/) to your application.  You can choose how the application should operate if the licence is missing or expired.
1. **23rd December:** Build an intelligence service that can read the date that [this photo](lib/photo-for-exif-extraction.jpg) was taken, as well as the GPS co-ordinates, and provide them as metadata suggestions.  You might use this C# library (https://www.nuget.org/packages/MetadataExtractor/) to extract the EXIF data.
    1. Tip: EXIF GPS data is held differently to the standard decimal latitude/longitude that you may have seen.  [Read this to convert between the two](https://gis.stackexchange.com/questions/136925/how-to-parse-exif-gps-information-to-lat-lng-decimal-numbers).
    1. Suggested extension: place the image into a workflow and use a state action and the COM API to read the suggestions and automatically apply them.
1. **24th December:** Create a new project using the "Custom External Object Type Data Source" Visual Studio template.  Implement a data source using the same data as you did on day #4.  Install and configure this data source.
    1. Tip: if using the same object type, disable your other application to stop the two trying to both work on the same objects.
    1. Consider the pros and cons of these two approaches; which do you feel you would use more, and why?

<!-- End of original "M-Files 12 Days" of Code Content -->

---

## Extended Structure created in January, 2022

*While the 12 Days of Code files could be found within the M-Files GitHub repository,  
 the following features from EWERK M-Files Solution were added to it,  
 using a separate branch called "*__EWERK-Style-Structure__*".*

#### Solution Items Structure

**Folder "<tt>Solution Items</tt>" containing the base folder of the solution**

*__Green__ background color within the table below mark the files which are already
 included after creating a M-Files VAF project in Visual Studio - originally without the enhancement.*

<table>
  <tr style="background-color: #ccc">
    <th align="left">Solution Item</th>
    <th align="left">Description</th>
  </tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>.editorconfig</tt></td>
    <td align="left">Created by Visual Studio persisting the editor setting</td>
  </tr>
  <tr style="background-color: #ddd">
    <td align="left"><tt>.gitattributes</tt></td>
    <td align="left">Creating file extension dependent  settings</td>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>.gitignore</tt></td>
    <td align="left">Files for local-only storing extended by EWERK Group</td>
  </tr>  
  <tr style="background-color: #ddd">
    <td align="left"><tt>ewerk.ico</tt></td>
    <td align="left">Customized VAF icon - Here: using EWERK logo</td>
  </tr>  
  <tr style="background-color: #eee">
    <td align="left"><tt>LICENSE.md</tt></td>
    <td align="left">Conditions for using the files - especially avoiding any warrenty using the Open Source clause "take it as it is and don't ask again".</td>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>README.md</tt></td>
    <td align="left">Original information about "12 Days of Code" as provided by M-Files plus additional descriptions of "EWERK-Style-Structure" elements.</td>
  </tr>
  <tr style="background-color: #ccc">
    <th colspan="2"/>
  </tr>
</table>

*The folder "*<tt>Solution Items</tt>*" contains the files which are located
 in the root folder of the solution exception the <tt>.sln</tt> file itself.*

*The following sub-section contain the content description of the virtual solution sub folders
 which are created similar to the physical folder structure.  
The feature of linking files from any folder of the solution was not used here in order to keep
the structure more understandable for people that look at this EWERK-Style-Structure the first time.*

*The project folders are included as projects - not as solutions items.*  
*Other folders can be created for example by the following systems:*

* Visual Studio IDE, e.g. "<tt>.vs</tt>",
* NuGET package manager "<tt>npm.exe</tt>", e.g. "<tt>packages</tt>" or
* MS Build process according its configuration, e.g. "<tt>out</tt>".

*As follows, you will find the sub-section for the solution items folder described directly below:*

**1. Sub-Folder "<tt>config</tt>" within "<tt>Solution Items</tt>" (by EWERK)**

*__Red__ background color stands for files which are __NOT__ syncronized with the Git(Hub) repository
 because it they are changed by creating the new version number while running the MS Build process.
 Otherwise it may cause GIT conflicts any time when the versions of diffenrent developers must be merged
 since every developer creeates other version numbers.*

*The version numbers were changed - supporting better developers-collaboration - into*  
<tt>[2-Digit-Year].[Month].[Hour].[Minute]</tt>  
*in order to have unique version numbers independent from storing the last version number used.*

*__Yellow__ background color stands for the connections configuration file  
which was designed by M-Files and used within the installation script code  
but only if the <tt>.json</tt> file has been created manually.*

<table>
  <tr style="background-color: #ccc">
    <th align="left">Config Item</th>
    <th align="left">Description</th>
  </tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>_README.md</tt></td>
    <td align="left">Detailled description of the config items</td>
  </tr>
  <tr style="background-color: #ffb">
    <td align="left"><tt>connections.json</tt></td>
    <td align="left">Default connections configurations file as foreseen within the installation script as provided by creating a new VAF project of version 2.3 by Visual Studio while the <tt>.json</tt> file must be created manually</td>
  </tr>
  <tr style="background-color: #fbb">
    <td align="left"><tt>connections.json.user</tt></td>
    <td align="left">Not included in GitHub repositiory - to be created by copying the file "<tt>connections.json</tt>"</td>
  </tr>
  <tr style="background-color: #ddd">
    <td align="left"><tt>version.props</tt></td>
    <td align="left">Variables which will be loaded into the <tt>.csproj</tt> file before startung a new MS Build process for a project.</td>
  </tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>version.txt</tt></td>
    <td align="left">Variables which will be loaded into the <tt>.csproj</tt> file before startung a new MS Build process for a project.</td>
  </tr>
  <tr style="background-color: #fbb">
    <td align="left"><tt>version.txt.user</tt></td>
    <td align="left">Variables which will be loaded into the <tt>.csproj</tt> file before startung a new MS Build process for a project.</td>
  </tr>  
  <tr style="background-color: #ccc">
    <th colspan="2"/>
  </tr>
</table>

---

**2. Sub-Folder "<tt>lib</tt>" within "<tt>Solution Items</tt>" (by M-Files)**

*This sub-folder contains 1-to-1 all content items used within the code  
as delivered within the master branch of "*<tt>TwelveDaysOfCode</tt>*"  
created originally by M-Files marked with __green__ background color.*

<table>
  <tr style="background-color: #ccc">
    <th align="left">Lib of Assets</th>
    <th align="left">Description</th>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>logo.png</tt></td>
    <td align="left">Logo used within the original code by M-Files</td>
  </tr>
  <tr style="background-color: #9d9">
    <td align="left"><tt>photo-for-exif-extraction.jpg</tt></td>
    <td align="left">Background image to be used for individual dashboard design within the original code by M-Files</td>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>sample-configuration.txt</tt></td>
    <td align="left">Template file wiith can be loaded as initial configuration.</td>
  </tr>  
  <tr style="background-color: #ccc">
    <th colspan="2"/>
  </tr>
</table>

---

**3. Sub-Folder "<tt>scripts</tt>" within "<tt>Solution Items</tt>" (by EWERK)**

*__Green__ background color stands for the installation script which was originally delivered by M-Files but modified since the EWERK-Style-Structure build logic differs from standard.*

<table>
  <tr style="background-color: #ccc">
    <th align="left">Script Item</th>
    <th align="left">Description</th>
  </tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>_README.md</tt></td>
    <td align="left">Detailled description of the script items</td>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>install-application.ps1</tt></td>
    <td align="left">Original VAF Installation script<br/>
but modified by EWERK Group</td>
  </tr>
  <tr style="background-color: #eee">
    <td align="left"><tt>update-EWER-version.ps1</tt></td>
    <td align="left">Version calculation script called<br/>
by the MS Build process<br/>
    as extended by EWERK Group</td>
  </tr>  
  <tr style="background-color: #ccc">
    <th colspan="2"/>
  </tr>
</table>

---

**4. Sub-Folder "<tt>vault-backup</tt>" within "<tt>Solution Items</tt>" (by M-Fies)**

*Only one file is necessary here because there is only one version of the vault backup file.  
The description for restoring the vault backup can be found within the M-Files Online manual  
using the following URL:*

- [Restoring a Document Vault](https://www.m-files.com/user-guide/latest/eng/Restore_document_vault.html)

*__Green__ background color stands for using the file as provided originally by M-Files.*

<table>
  <tr style="background-color: #ccc">
    <th align="left">Vault Backup</th>
    <th align="left">Description</th>
  </tr>
  <tr style="background-color: #bfb">
    <td align="left"><tt>Twelve-Days-Of-Code.mfb</tt></td>
    <td align="left">Vault backup as <tt>.mfb</tt> file which was created by M-Files for creating a developer vault for this topic.</td>
  </tr>  
  <tr style="background-color: #ccc">
    <th colspan="2"/>
  </tr>
</table>

*Delivering a vault backup file is not necessary for every VAF project depending on the requirements.*

---

## Basic UIX project / Build order

**Common Ideas / Lessons Learned for creating the EWERK-Style-Structure**

1. The UIX project template is designed for using it as sub application
   of the VAF appication. Both shoud be included into
   a single <tt>.mfappx</tt> file for installing both,
   VAF and UIX application, during the general installation
   of the <tt>.mfappx</tt> file, see developer porta
   for a detailled description how to configure
   it.
1. If we want to set the correct version number also into the compiled
   <tt>.dll</tt> files then we have to update the <tt>AssemblyInfo.cs</tt>
   files of projets with C# code __BEFORE__ loading the project
   as first step of the MS Build process using the standard .NET
   compile process which is used by the standard Visual Studio Build.
1. First solution was a separate C# library project where the contents
   were thrown after creating the version number
   within the build of this dummy project.
1. Almost every server-side customization via VAF could cause
   also a client-side customization using UIX. This can be done by including
   the UIX files as a sub-folder within the VAF project.
1. Because UIX projects are based on HTML5 technology including pure JavaSript
   or a JavaScript library like AngularJS or VueJS there is no relevant
   C# code which has to be compiled. Therefore the version number must be
   set only into files which can be modified and copied after the
   MS Build process for UIX projects.
1. If the <tt>.mfappx</tt> file of the UIX project should be included
   as sub-application into the <tt>.mfappx</tt> file of the VAF project
   then the VAF project's Build Dependecies must be configured that the
   VAF build starts only after the UIX build has been completed.
1. Those restriction are ideal for placing the version number creation
   including modifying <tt>AssemblyInfo.cs</tt> file(s) within the build
   logic of the UIX project. After configuring the build in that way
   the version number of the <tt>.dll</tt> file equals the version number
   within the <tt>appdef.xml</tt> files delivered as part of the
   <tt>.mfappx</tt> files for VAF application and UIX application.
1. Before that the <tt>.dll</tt> files contained always the last
   version number as stored in <tt>AssembyInfo.cs</tt> before the
   MS build process started. This bug won't exist any more after
   the changes described here.
1. The <tt>.csproj</tt> files were incremently updated with
   each added file etc. by Visual Studio. Therefore the real build
   logic has been put into the <tt>.targets</tt> files which are included
   within each project, namely:
   * <tt>uix-project.targets</tt> used by the build of the UIX project (first)<br/>and
   * <tt>uix-project.targets</tt> used by the build of the VAF project (afterwards)

---

**DISCLAIMER:**
This solution is provided by EWERK and
there is no review/support by M-Files as vendor
of the system directly, but by EWERK Group as a fully
qualified M-Files partner.

---

**Copyright &copy; 2020 - 2022 by EWERK Group, ECM/DMS Practise**  
See [LICENSE.md](LICENSE.md) for further information.