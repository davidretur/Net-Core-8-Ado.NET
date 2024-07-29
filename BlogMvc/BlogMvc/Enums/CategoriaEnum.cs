using System.ComponentModel;

namespace BlogMvc.Enums
{
    public enum CategoriaEnum
    {
        [Description("Noticias recientes")]
        Noticias,

        [Description("Opiniones y comentarios")]
        Opinion,

        [Description("Novedades en tecnología")]
        Tecnologia,

        [Description("Guías y tutoriales")]
        Tutoriales,

        [Description("Recursos útiles")]
        Recursos
    }
}
