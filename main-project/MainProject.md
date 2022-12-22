## Main Project

### Project generation
Use the following command to generate your project with Maven, where `team` and `product` should be replaced accordingly:

For macOS and Linux:
```
mvn org.apache.maven.plugins:maven-archetype-plugin:3.1.0:generate \
-DarchetypeGroupId=fielden \
-DarchetypeArtifactId=tg-application-archetype \
-DarchetypeVersion="1.4.6-SNAPSHOT" \
-DgroupId=team \
-DartifactId=product \
-Dversion="1.0-SNAPSHOT" \
-Dpackage=team \
-DcompanyName="Your team full name" \
-DplatformVersion="1.4.6-SNAPSHOT" \
-DprojectName="Your product full name." \
-DprojectWebSite="https://product.team.com.ua" \
-DsupportEmail="product_support@team.com.ua" \
-DemailSmpt="localhost"
```

For Windows:
```
mvn org.apache.maven.plugins:maven-archetype-plugin:3.1.0:generate -DarchetypeGroupId=fielden -DarchetypeArtifactId=tg-application-archetype -DarchetypeVersion="1.4.6-SNAPSHOT" -DgroupId=team -DartifactId=product -Dversion="1.0-SNAPSHOT" -Dpackage=team -DcompanyName="Your team full name" -DplatformVersion="1.4.6-SNAPSHOT" -DprojectName="Your product full name." -DprojectWebSite="https://product.team.com.ua" -DsupportEmail="product_support@team.com.ua" -DemailSmpt="localhost"
```
