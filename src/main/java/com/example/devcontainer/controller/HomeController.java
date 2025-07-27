package com.example.devcontainer.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

@Controller
public class HomeController {

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("title", "Spring Boot アプリ");
        model.addAttribute("message", "今度こそホットリロードが動作します！🚀✨");
        model.addAttribute("currentTime", LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyy年MM月dd日 HH:mm:ss")));
        return "index";
    }

    @GetMapping("/hello")
    public String hello(@RequestParam(name = "name", defaultValue = "world") String name, Model model) {
        model.addAttribute("title", "挨拶ページ");
        model.addAttribute("name", name);
        model.addAttribute("greeting", "こんにちは、" + name + "さん！");
        return "hello";
    }

    @GetMapping("/about")
    public String about(Model model) {
        model.addAttribute("title", "このアプリについて");
        model.addAttribute("description", "このアプリケーションはSpring Boot 3.5.4で作成されています。");
        model.addAttribute("features", new String[]{
            "Spring Boot Web",
            "Thymeleaf テンプレートエンジン",
            "Spring Boot DevTools",
            "Dev Container対応"
        });
        return "about";
    }
}
