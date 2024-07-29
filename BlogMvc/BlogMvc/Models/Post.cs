using System.ComponentModel.DataAnnotations;

namespace BlogMvc.Models
{
    public class Post
    {

        public int PostId { get; set; }

        [Required(ErrorMessage = "El titulo es requerido.")]
        [StringLength(100, MinimumLength = 5, ErrorMessage = "El titulo debe tener entre 5 y 100 caracteres.")]
        public string? Titulo { get; set; }

        [Required(ErrorMessage = "El contenido es requerido.")]
        [StringLength(100, MinimumLength = 5, ErrorMessage = "El contenido debe tener entre 50 y 5000 caracteres.")]
        public string? Contenido { get; set; }

        [Required(ErrorMessage = "La categoria es requerida.")]
        public CategoriaEnum Categoria { get; set; }

        [Required(ErrorMessage = "Fecha de creacion requerida.")]
        public DateTime FechaCreacion { get; set; }
    }
}
