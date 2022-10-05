SELECT FL.FILM_ID AS film_id,           -- идентификатор фильма
        FL.NAME AS name,                -- название
        FL.DESCRIPTION AS description,  -- описание
        FL.RELEASE_DATE AS release_date,-- дата релиза
        FL.DURATION_IN_MINUTES AS duration_in_minutes,  -- продолжительность в минутах
        FL.MPA_RATING_ID AS mpa_rating_id,              -- идентификатор рейтинга MPA
        M.MPA_NAME AS mpa_rating_name,  -- наименование рейтинга MPA
        GE.GENRE_ID AS GENRE_ID,        -- идентификатор жанра
        GE.GENRE_NAME AS GENRE_NAME,    -- название жанра
        (SELECT sum(FILM_LIKES.USER_ID)
         FROM FILM_LIKES
         WHERE FILM_LIKES.FILM_ID = FL.FILM_ID
        ) AS rate                       -- количество лайков у фильма

FROM FILMS AS FL                        -- таблица с фильмами
    LEFT JOIN MPA_RATING AS M ON FL.MPA_RATING_ID = M.MPA_RATING_ID -- связь таблиц Фильмы -< MPA
    LEFT JOIN FILM_GENRES AS FG ON FL.FILM_ID = FG.FILM_ID          -- связь с таблицей составных ключей Жанры >-< Фильмы
    LEFT JOIN GENRES AS GE ON FG.GENRE_ID = GE.GENRE_ID             -- связь таблиц между FILMS(фильмы) и GENRE(жанры)
    LEFT JOIN FILM_LIKES AS LF ON FL.FILM_ID = LF.FILM_ID           -- связь с таблицей составных ключей Фильмы >-< User

WHERE FL.FILM_ID IN (SELECT F_L.FILM_ID
                        FROM FILM_LIKES F_L
                        WHERE USER_ID = ? AND FILM_ID IN (SELECT FILM_ID
                                                            FROM FILM_LIKES F_L_FRI
                                                            WHERE F_L_FRI.USER_ID = ?
                                                         )
                    )

GROUP BY GENRE_NAME, FL.FILM_ID
ORDER BY rate DESC, FL.FILM_ID, GENRE_NAME                 -- количество выгружаемых записей
