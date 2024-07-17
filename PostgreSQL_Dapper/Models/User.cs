using Newtonsoft.Json.Linq;

namespace PostgreSQL_Dapper.Models
{
    public class User
    {
        public int Id { get; set; } 
        public string Name { get; set; }
        public string Email { get; set; }
        public JObject AdditionalInfo { get; set; }
    }
}
