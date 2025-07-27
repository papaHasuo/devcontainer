package com.example.devcontainer.controller;

import com.example.devcontainer.entity.User;
import com.example.devcontainer.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;

@Controller
public class HomeController {

    @Autowired
    private UserService userService;

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
        model.addAttribute("description", "このアプリケーションはSpring Boot 3.5.4 + MyBatisで作成されています。");
        model.addAttribute("features", new String[]{
            "Spring Boot Web",
            "Thymeleaf テンプレートエンジン",
            "MyBatis",
            "Spring Boot DevTools",
            "Dev Container対応"
        });
        return "about";
    }

    @GetMapping("/users")
    @ResponseBody
    public List<User> getUsers() {
        try {
            return userService.getAllUsers();
        } catch (Exception e) {
            // テーブルが存在しない場合は空のリストを返す
            return List.of();
        }
    }
}
