package vn.iotstar.config;

import java.nio.file.Paths;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
public class WebMvcConfig implements WebMvcConfigurer {

    @Autowired
    private AdminSecurityInterceptor adminSecurityInterceptor;

    @Value("${app.upload.dir:uploads}")
    private String configuredUploadDirectory;

    @Bean
    public org.springframework.web.servlet.view.InternalResourceViewResolver viewResolver() {
        org.springframework.web.servlet.view.InternalResourceViewResolver resolver = new org.springframework.web.servlet.view.InternalResourceViewResolver();
        resolver.setPrefix("/WEB-INF/views/");
        resolver.setSuffix(".jsp");
        resolver.setViewClass(org.springframework.web.servlet.view.JstlView.class);
        resolver.setAlwaysInclude(true);
        resolver.setContentType("text/html;charset=UTF-8");
        return resolver;
    }

    @Bean
    public FilterRegistrationBean<MySiteMeshFilter> siteMeshFilter() {
        FilterRegistrationBean<MySiteMeshFilter> filterReg = new FilterRegistrationBean<>();
        filterReg.setFilter(new MySiteMeshFilter());
        filterReg.addUrlPatterns("/*");
        filterReg.setOrder(1);
        return filterReg;
    }

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        // Bao ve toan bo cac duong dan quan tri /admin/**
        registry.addInterceptor(adminSecurityInterceptor)
                .addPathPatterns("/admin/**");
    }

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {
        String uploadDir = Paths.get(configuredUploadDirectory).toAbsolutePath().toUri().toString();
        registry.addResourceHandler("/uploads/**")
                .addResourceLocations(uploadDir);

        registry.addResourceHandler("/static/**")
                .addResourceLocations("classpath:/static/");
    }
}
