## Systems Analysis and Design 2022

### Main project
For details related to the main project visit the [Main project](main-project/MainProject.md) page.

### Important modification that has to be applied manually
Inside the generated `airport` project open `airport-web-server/application.properties` file and replace lines 48-52 with the following: 
```
hibernate.connection.url=jdbc:postgresql://localhost:5432/tg_local
hibernate.connection.driver_class=org.postgresql.Driver
hibernate.dialect=org.hibernate.dialect.PostgreSQLDialect
hibernate.connection.username=t32
hibernate.connection.password=t32
```

This should resolve the issue with being uable to start the web server using `StartOverHttp`.
Specifically, if you encountered an error that said: `FATAL: Password authentication failed for user 'sa'*` it was due to the misconfiguration during the project generation phase.
After performing the above modification, please make sure that you can launch `StartOverHttp`. 
Also don't forget that the database and HAProxy Docker containers have to be running before starting the web server.

### FAQ
For Frequently Asked Questions and troubleshooting go to [FAQ](faq/FAQ.md).

### Initial environment setup
First of all, clone this repository to a suitable location on your machine:
```
git clone https://github.com/fieldenms/sysad-2022
```

#### Java
We will be using Java 17. You can check your Java version by running the following command on the console: `java --version`.
If your version is lower or if you haven't got Java on your machine at all, then install it using one of the following links:

- [Windows](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_windows_hotspot_17.0.4.1_1.msi) - enable the option that says *Set JAVA_HOME variable*.
- [macOS](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_mac_hotspot_17.0.4.1_1.pkg)
- [Linux](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_linux_hotspot_17.0.4.1_1.tar.gz)

What you are installing is a distribution of OpenJDK from [Adoptium](https://adoptium.net/temurin/releases).

Next, you need to set the `JAVA_HOME` environment variable.

- Windows - the installer should have done this for you if you enabled the option related to `JAVA_HOME`.
    
    If it hadn't, then you have to do it [manually](https://docs.oracle.com/en/cloud/saas/enterprise-performance-management-common/diepm/epm_set_java_home_104x6dd63633_106x6dd6441c.html). 
    The JDK was probably installed at `C:\Program Files\Eclipse Adoptium\jdk-17.0.4.101-hotspot`.

    Make sure that `JAVA_HOME` and `Path` are set correctly:

    ![Windows 10 JAVA_HOME and Path settings](images/win10-java_home-and-path.png)
- macOS
    
    The default shell might be either `bash` or `zsh`, so simply update both of them by runing the following 2 commands:
    ```
    printf 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"\nexport PATH="$PATH:$JAVA_HOME/bin"' >> ~/.bashrc
    ```
    ```
    printf 'export JAVA_HOME="/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home"\nexport PATH="$PATH:$JAVA_HOME/bin"' >> ~/.zshrc
    ```
    Restart the terminal for the changes to take effect.
- Linux
    
    First, unpack the archive you downloaded with `tar -xf PATH_TO_ARCHIVE`. This will create a directory `jdk-17.0.4.1+1` in the current one. You can move it to a suitable location if you want.
    
    The default shell might be either `bash` or `zsh`, so simply update both of them by runing the following 2 commands, replacing `PATH_TO_JKD_DIR` with the path to `jdk-17.0.4.1+1`:
    ```
    printf 'export JAVA_HOME="PATH_TO_JDK_DIR"\nexport PATH="$PATH:$JAVA_HOME/bin"' >> ~/.bashrc
    ```
    ```
    printf 'export JAVA_HOME="PATH_TO_JDK_DIR"\nexport PATH="$PATH:$JAVA_HOME/bin"' >> ~/.zshrc
    ```
    Restart the terminal for the changes to take effect.
    
After the installation is done, you can verify it by running `java --version`. The output should look similar to the following:
```
openjdk 17.0.4.1 2022-08-12
OpenJDK Runtime Environment Temurin-17.0.4.1+1 (build 17.0.4.1+1)
OpenJDK 64-Bit Server VM Temurin-17.0.4.1+1 (build 17.0.4.1+1, mixed mode, sharing)
```

#### Maven
[Apache Maven](https://maven.apache.org/) is a build system for Java projects that we will be using. If you haven't got Maven on your machine, then you need to install it.

Maven can be downloaded [here](https://maven.apache.org/download.cgi). Grab the *Binary zip archive*. Since there is no provided installer, the installation process requires a bit more effort.

- Windows installation instructions can be found [here](https://toolsqa.com/maven/how-to-install-maven-on-windows/) (skip the *install Java* part).
- macOS installation instructions - [here](https://www.digitalocean.com/community/tutorials/install-maven-mac-os) (skip the *install Java* part).
- Linux installation instructions (I doubt you need them :)) - [here](https://maven.apache.org/install.html)

    MacOS and Linux users should also edit their `~/.bashrc` to include the following line, replacing `YOUR_MAVEN_DIRECTORY` by the location where you downloaded Maven to.
    ```
    export PATH="YOUR_MAVEN_DIRECTORY/bin:$PATH"
    ```
    For example, if you downloaded maven and unzipped it to `/Users/username/maven` (macOS), then:
    ```
    export PATH="/Users/username/maven/bin:$PATH"
    ```
    On Linux that would be `/home` instead of `/Users`.

Verify your installation with `mvn -version`. Make sure that `mvn` command is run and that the indicated Java version is 17 or newer.

More information:

- [https://maven.apache.org/install.html](https://maven.apache.org/install.html)
- [https://duckduckgo.com/?q=how+to+install+maven](https://duckduckgo.com/?q=how+to+install+maven)

#### TG Maven settings
File [`settings.xml`](tg-maven-settings/settings.xml) needs to have section `<server>` completed by specifying `<username>` and `<password>`, which should be your GitHub username and a personal token generated using GitHub.
Such token should be generated with option `read:packages` using *GitHub->Settings->Developer settings->Personal* access tokens menu.

Put file `settings.xml` into the directory for your local Maven repo, which usually is `~/.m2`. Symbol `~` stands for the user home directory. Under Windows, this would be `C:\Users\<username>\.m2\`.

#### TG archetype
1. Navigate to the directory with the archetype that contains jar and pom files to install the archetype locally on your system.
    - `cd tg-archetype`
    - `mvn install:install-file -Dfile=tg-application-archetype-1.4.6-SNAPSHOT.jar -DpomFile=pom.xml`

2. Update local archetype catalog: `mvn archetype:update-local-catalog`
3. Now we need to generate the project structure. This should be done from **another directory** (NOT from `tg-archetype` and NOT from this cloned repository). So simply go create a new directory somewhere like `Desktop/system-analysis` and run the following command inside it. A new directory `airport` will be generated upon running this command.

For Linux and macOS:
```
mvn -o org.apache.maven.plugins:maven-archetype-plugin:3.1.0:generate \
-DarchetypeGroupId=fielden \
-DarchetypeArtifactId=tg-application-archetype \
-DarchetypeVersion=1.4.6-SNAPSHOT \
-DgroupId=helsinki \
-DartifactId=airport \
-Dversion=1.0-SNAPSHOT \
-Dpackage=helsinki \
-DcompanyName="Helsinki Asset Management Pty. Ltd." \
-DplatformVersion=1.4.6-SNAPSHOT \
-DprojectName="Helsinki Airport Asset Management" \
-DprojectWebSite=https://airport.helsinki.com.ua \
-DsupportEmail=airport_support@helsinki.com.ua \
-DemailSmtp=localhost
```

For Windows:
```
mvn org.apache.maven.plugins:maven-archetype-plugin:3.1.0:generate -DarchetypeGroupId=fielden -DarchetypeArtifactId=tg-application-archetype -DarchetypeVersion="1.4.6-SNAPSHOT" -DgroupId=helsinki -DartifactId=airport -Dversion="1.0-SNAPSHOT" -Dpackage=helsinki -DcompanyName="Helsinki Asset Management Pty. Ltd." -DplatformVersion="1.4.6-SNAPSHOT" -DprojectName="Helsinki Airport Asset Management" -DprojectWebSite="https://airport.helsinki.com.ua" -DsupportEmail="airport_support@helsinki.com.ua" -DemailSmtp="localhost"
```

Note that `-DemailSmtp` points to `localhost`. We will be running a local SMTP server in a Docker container. More on that later.

4. Navigate to the generated `airport` directory and make sure it compiles successfully.
    - `cd airport`
    - `mvn clean compile`

<!--
5. Generate project files for the Eclipse IDE in order for this project to be recognizable.
```
mvn eclipse:eclipse -DdownloadSources -DdownloadJavadoc
```
`-DdownloadSources` and `-DdownloadJavadoc` options will allow you to browse the source code and documentation of project dependencies.
-->

#### Download and install Eclipse IDE
- [Windows](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-06/R/eclipse-java-2022-06-R-win32-x86_64.zip)
    
    Note that this is not an installer program, but a zip archive that contains the program. 
    You should unzip it after downloading and put the resulting directory somewhere suitable on your system, e.g. on your Desktop.
    To launch Eclipse simply open that directory and start `eclipse.exe`.
- [macOS](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-06/R/eclipse-java-2022-06-R-macosx-cocoa-x86_64.dmg)
- [Linux](https://www.eclipse.org/downloads/download.php?file=/technology/epp/downloads/release/2022-06/R/eclipse-java-2022-06-R-linux-gtk-x86_64.tar.gz)


#### Importing projects into Eclipse
1. Import the `airport` project into Eclipse.
    - Open Eclipse IDE.
    - *File->Import->Existing Maven Projects*.
    - Set *Root Directory* to the `airport` directory.
    - *Finish*.

2. Configure run configurations for Eclipse.
    - Open Eclipse IDE.
    - Open a file named `PopulateDb.java`. It's located under `airport-web-server/src/test/java` inside `helsinki.dev_mod.util` package. You can also use `Ctrl+Shift+T` (`Cmd+Shift+T` on macOS) to find it quickly.
    - Right click -> *Run As* -> *Run Configurations* -> *Java Application* -> *New launch configuration* (Left-upper corner, the first icon) -> *Arguments* tab. 
    - In the *VM arguments* text box enter:
    ```
    -Dlog4j.configurationFile=src/main/resources/log4j2.xml
    --add-opens java.base/java.lang=ALL-UNNAMED
    ```
    - Do the same for `StartOverHttp.java`, which is located under `airport-web-server/src/main/java` inside `helsinki.webapp` package.

    The `PopulateDb` class is responsible for populating initial data for starting the application, such as a *bootstrap* user.
    It is required to run this configuration every time you reset your database, before starting the web server.

    The `StartOverHttp` class is responsible for actually starting the web server. 
    There is also a class named `Start`, but we will be starting over `HTTP`, since we will be using `HAProxy` to make our web application recognized as *legitimate* by the web browser.
    More on that later in this note.

3. Enable annotation processing in Eclipse.
    a. In the *Package Explorer* pane on the left select `airport-pojo-bl` project:

    ![Selecting airport-pojo-bl](images/01-eclipse-apt.png)

    b. Right-click on it -> *Properties*. 
    c. Navigate to *Java Compiler* -> *Annotation Processing*, tick the box *Enable project specific settings*, then hit *Apply and Close* and finally *Yes*.
    
    ![Enabling project specific settings](images/02-eclipse-apt.png)

    ![Yes](images/03-eclipse-apt.png)

    This should resolve the compilation errors.

#### TG Eclipse plugin
We will be using a plugin that makes development of TG applications more convenient.
To install it you need to copy the `*.jar` files that can be found [here](dropins) to a directory named `dropins` in your local Eclipse installation.

- Windows guys, remeber when we told you to put the unzipped Eclipse folder somewhere suitable? I hope you remember where it was. Now go there and open it. There should be a `dropins` directory inside.

- macOS guys, a file `Eclipse.app` should be located in `/Applications`. You can also find it using the standard `Finder` program inside `Applications`. Then right-click and *Show Package Contents*. 
Put the `*.jar` files inside `Contents/Eclipse/dropins`. Eclipse needs to be restarted for plugins to be loaded.

- Linux guy, the same goes for you, find your local eclipse installation and there should be a `dropins` directory inside.

#### TG Eclipse templates
TG templates for Eclipse provide convenient code snippets to facilitate definition of entity properties and EQL queries.

The [template file](tg-eclipse-templates/tg-templates.xml) should be imported into Eclipse from menu *Preferences->Java->Editor->Templates*.

The recommended TG [code formatting file](tg-eclipse-templates/code-formatting-template.xml) should be imported into Eclipse from menu *Preferences->Java->Code Style->Formatter*.

#### Github repo setup
Grab the files from [github-repo-setup](github-repo-setup) and put them inside your project directory (`airport`).

#### Update hosts file
Domain name `tgdev.com` needs to be configured in the hosts file to be resolvable to the `localhost` (`127.0.0.1`).

Under macOS or Linux this file is `/etc/hosts`.
Under Windows this file is `C:\Windows\System32\drivers\etc\hosts`
In all cases this file needs to be edited with administrative privileges.
The following entry needs to be added:
```
127.0.0.1   tgdev.com
```

### Next steps
Take a break now and then head over to [devops](devops) to configure Docker to run supporting services.

