using System.ComponentModel.DataAnnotations.Schema;

namespace BlogMvc.Models
{
    public class Comentario
    {
        public int ComentarioId { get; set; }
        public string? Contenido { get; set; }
        public DateTime FechaCreacion { get; set; }
        public int UsuarioId { get; set; }
        public int PostId { get; set; }
        public int? ComentarioPadreId { get; set; }
        public List<Comentario>? ComentariosHijos { get; set; }
        [NotMapped]
        public string? NombreUsuario { get; set; }
        public int? ComentarioAbueloId { get; set; }
    }
}
