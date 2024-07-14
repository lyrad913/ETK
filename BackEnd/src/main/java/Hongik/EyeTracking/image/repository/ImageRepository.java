package Hongik.EyeTracking.image.repository;

import Hongik.EyeTracking.image.domain.Image;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ImageRepository extends JpaRepository<Image, Integer> {
    List<Image> findByUserId(Long userId);
}
