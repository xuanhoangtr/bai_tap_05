package vn.iotstar.config;

import org.sitemesh.builder.SiteMeshFilterBuilder;
import org.sitemesh.config.ConfigurableSiteMeshFilter;

public class MySiteMeshFilter extends ConfigurableSiteMeshFilter {

    @Override
    protected void applyCustomConfiguration(SiteMeshFilterBuilder builder) {
        builder.setDispatchMode(org.sitemesh.webapp.DispatchMode.INCLUDE)
               .setMimeTypes("text/html", "application/xhtml+xml")
               
               // 1. Decorator Admin
               .addDecoratorPath("/admin/*", "admin.jsp")
               .addDecoratorPath("/admin", "admin.jsp")
               
               // 2. Decorator Web
               .addDecoratorPath("/home*", "web.jsp")
               
               // 3. Excluded Paths
               .addExcludedPath("/login*")
               .addExcludedPath("/logout*")
               .addExcludedPath("/image*")
               .addExcludedPath("/uploads/*")
               .addExcludedPath("/WEB-INF/decorators/*")
               .addExcludedPath("/decorators/*")
               .addExcludedPath("/static/*")
               .addExcludedPath("/assets/*");
    }
}
