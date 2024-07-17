using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using PostgreSQL_Dapper.Models;
using PostgreSQL_Dapper.Repositories;

namespace PostgreSQL_Dapper.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UserController : ControllerBase
    {
        private readonly UserRepository _UserRepository;

        public UserController(UserRepository UserRepository)
        {
            _UserRepository = UserRepository;
        }

        [HttpGet]
        public async Task<ActionResult<IEnumerable<User>>> Get()
        {
            var Users = await _UserRepository.Get();
            return Ok(Users);
        }

        [HttpGet("{id}")]
        public async Task<ActionResult<User>> Get(int id)
        {
            var User = await _UserRepository.Get(id);
            if (User == null)
            {
                return NotFound();
            }
            return Ok(User);
        }

        [HttpPost]
        public async Task<ActionResult> Post([FromBody] User User)
        {
            var id = await _UserRepository.Add(User);
            return CreatedAtAction(nameof(Get), new { id }, User);
        }

        [HttpPut("{id}")]
        public async Task<ActionResult> Put(int id, [FromBody] User User)
        {
            if (id != User.Id)
            {
                return BadRequest();
            }

            var existingUser = await _UserRepository.Get(id);
            if (existingUser == null)
            {
                return NotFound();
            }

            await _UserRepository.Update(User);
            return NoContent();
        }

        [HttpDelete("{id}")]
        public async Task<ActionResult> Delete(int id)
        {
            var existingUser = await _UserRepository.Get(id);
            if (existingUser == null)
            {
                return NotFound();
            }

            await _UserRepository.Delete(id);
            return NoContent();
        }

        [HttpGet("bydepartment/{department}")]
        public async Task<ActionResult<IEnumerable<User>>> GetByDepartment(string department)
        {
            var user = await _UserRepository.GetUsersByDepartment(department);
            return Ok(user);
        }
    }
}
