## Systems Analysis and Design 2022

### Initial environment setup
First of all, clone this repository to a suitable location on your machine:
```
git clone https://github.com/fieldenms/sysad-2022
```

#### Java
We will be using Java 17. You can check your Java version by running the following command on the console: `java --version`.
If your version is lower or if you haven't got Java on your machine at all, then install it using one of the following links:

- [Windows](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_windows_hotspot_17.0.4.1_1.msi)
- [macOS](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_mac_hotspot_17.0.4.1_1.pkg)
- [Linux](https://github.com/adoptium/temurin17-binaries/releases/download/jdk-17.0.4.1%2B1/OpenJDK17U-jdk_x64_linux_hotspot_17.0.4.1_1.tar.gz)

What you are installing is a distribution of OpenJDK from [Adoptium](https://adoptium.net/temurin/releases).

Note for Linux users: don't forget to set the `JAVA_HOME` environment variable.

After the installation is done, you can verify it by running `java --version`.

#### Maven
[Apache Maven](https://maven.apache.org/) is a build system for Java projects that we will be using. If you haven't got Maven on your machine, then you need to install it.

Maven can be downloaded [here](https://maven.apache.org/download.cgi). Grab the *Binary zip archive*. Since there is no provided installer, the installation process requires a bit more effort.

- Windows installation instructions can be found [here](https://toolsqa.com/maven/how-to-install-maven-on-windows/) (skip the *install Java* part).
- macOS installation instructions - [here](https://www.digitalocean.com/community/tutorials/install-maven-mac-os) (skip the *install Java* part).
- Linux installation instructions (I doubt you need them :)) - [here](https://maven.apache.org/install.html)

    Edit your `~/.bash_profile` to include the following line:
    ```
    export PATH="<YOUR_MAVEN_DIRECTORY/bin>:$PATH"
    ```
    For example, if you downloaded maven and unzipped it to `/home/username/maven`, then:
    ```
    export PATH="/home/username/maven/bin:$PATH"
    ```

Verify your installation with `mvn -version`.

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
3. Generate the project structure. This can be done from any directory you want. Directory `airport` will be generated.

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

5. Generate project files for the Eclipse IDE in order for this project to be recognizable.
```
mvn eclipse:eclipse -DdownloadSources -DdownloadJavadoc
```

`-DdownloadSources` and `-DdownloadJavadoc` options will allow you to browse the source code and documentation of project dependencies.

6. Import the project into Eclipse.
    - Open Eclipse IDE.
    - *File->Import->Existing Maven Projects*.
    - Set *Root Directory* to the `airport` directory.
    - *Finish*.

7. Configure run configurations for Eclipse.
    - Open Eclipse IDE.
    - Open a file named `PopulateDb.java`. It's located under `airport-web-server/src/main/java` inside `helsinki.dev_mod.util` package. You can also use `Ctrl+Shift+T` (`Cmd+Shift+T` on macOS) to find it quickly.
    - Right click -> *Run As* -> *Run Configurations* -> *New launch configuration* -> *Arguments* tab. 
    - In the *VM arguments* text box enter:
    ```
    -Dlog4j.configurationFile=src/main/resources/log4j2.xml
    -Djava.system.class.loader=ua.com.fielden.platform.classloader.TgSystemClassLoader
    --add-opens java.base/java.lang=ALL-UNNAMED
    ```
    - Do the same for `StartOverHttp.java`, which is located under `airport-web-server/src/main/java` inside `helsinki.webapp` package.

    The `PopulateDb` class is responsible for populating initial data for starting the application, such as a *bootstrap* user.
    It is required to run this configuration every time you reset your database, before starting the web server.

    The `StartOverHttp` class is responsible for actually starting the web server. 
    There is also a class named `Start`, but we will be starting over `HTTP`, since we will be using `HAProxy` to make our web application recognized as *legitimate* by the web browser.
    More on that later in this note.

#### TG Eclipse plugin
We will be using a plugin that makes development of TG applications more convenient.
To install it you need to copy the `*.jar` files that can be found [here](dropins) to a directory named `dropins` in your local Eclipse installation.

For macOS a file `Eclipse.app` should be located in `/Applications`. You can also find it using the standard `Finder` program inside `Applications`. Then right-click and *Show Package Contents*. 

Put the `*.jar` files inside `Contents/Eclipse/dropins`. Eclipse needs to be restarted for plugins to be loaded.

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

