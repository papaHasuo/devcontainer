package com.example.devcontainer.controller;

import com.example.devcontainer.entity.User;
import com.example.devcontainer.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

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
    public String usersPage(Model model) {
        try {
            List<User> users = userService.getAllUsers();
            model.addAttribute("title", "ユーザー一覧");
            model.addAttribute("users", users);
        } catch (Exception e) {
            // テーブルが存在しない場合は空のリストを設定
            model.addAttribute("title", "ユーザー一覧");
            model.addAttribute("users", List.of());
            model.addAttribute("error", "データベースに接続できないか、ユーザーテーブルが存在しません。");
        }
        return "users";
    }

    @GetMapping("/api/users")
    @ResponseBody
    public List<User> getUsersApi() {
        try {
            return userService.getAllUsers();
        } catch (Exception e) {
            // テーブルが存在しない場合は空のリストを返す
            return List.of();
        }
    }

    @GetMapping("/user/create")
    public String createUserPage(Model model) {
        model.addAttribute("title", "ユーザー作成");
        model.addAttribute("user", new User());
        return "user_create";
    }

    @PostMapping("/user/create")
    public String createUser(@ModelAttribute User user, RedirectAttributes redirectAttributes) {
        try {
            userService.createUser(user);
            redirectAttributes.addFlashAttribute("successMessage", "ユーザー「" + user.getName() + "」を作成しました。");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("errorMessage", "ユーザーの作成に失敗しました: " + e.getMessage());
        }
        return "redirect:/users";
    }
}
