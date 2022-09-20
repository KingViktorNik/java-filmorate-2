package ru.yandex.practicum.filmorate.controller;


import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import ru.yandex.practicum.filmorate.model.Genre;
import ru.yandex.practicum.filmorate.service.genre.GenreService;

import javax.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/genres")
public class GenreController {

    private final GenreService genreService;

    public GenreController(GenreService genreService) {
        this.genreService = genreService;
    }

    @GetMapping
    public ResponseEntity<List<Genre>> read() {
        return ResponseEntity.ok(genreService.getAll());
    }

    @GetMapping(value = "/{id}")
    public ResponseEntity<Genre> read(@Valid @PathVariable Integer id) {
        return ResponseEntity.ok(genreService.getById(id));
    }

}
