using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using AutoMapper;
using Commander.Data;
using Commander.Dtos;
using Commander.Models;
using Microsoft.AspNetCore.JsonPatch;
using Microsoft.AspNetCore.Mvc;

namespace Commander.Controllers
{
    [Route("api/commands")]
    [ApiController]
    public class CommandsController : ControllerBase
    {
        // trebuie sa modificam actiunile astfel incat sa returneze
        // obiecte corespunzatoare dto-urilor
        private readonly ICommanderRepo _repository;
        private readonly IMapper _mapper;

        // trebuie sa declaram un controller
        public CommandsController(ICommanderRepo repository, IMapper mapper)
        {
            _repository = repository;
            _mapper = mapper;
        }


        // GEt api/commands
        // vor raspunde la req de tip http get
        [HttpGet]
        public ActionResult<IEnumerable<CommandReadDto>> GetAppCommands()
        {
            // variabila ce retine comenzile din "baza de date"
            var commandsItem = _repository.GetAppCommands();
            // 200 success
            return Ok(_mapper.Map<IEnumerable<CommandReadDto>>(commandsItem));
        }

        // GET api/commands/{id}
        [HttpGet("{id}", Name = "GetCommandById")]
        public ActionResult<CommandReadDto> GetCommandById(int id)
        {   // acel id dat ca parametru vine din request(derivat direct din URI)
            // variabila ce retine doar comanda cu id-ul dat
            var commandItem = _repository.GetCommandById(id);
            if (commandItem != null)
            {
                return Ok(_mapper.Map<CommandReadDto>(commandItem));
            }
            return NotFound();
        }

        // adaugam o comanda noua in baza de date
        // POST api/commands
        [HttpPost]
        public ActionResult<CommandReadDto> CreateCommand([FromBody] CommandCreateDto cmd)
        {
            var commandModel = _mapper.Map<Command>(cmd);
            _repository.CreateCommand(commandModel);
            _repository.SaveChanges();
            var commandReadDto = _mapper.Map<CommandReadDto>(commandModel);
            return CreatedAtRoute(nameof(GetCommandById), new { Id = commandReadDto.Id }, commandReadDto);
            //return Ok(commandReadDto);
        }

        // PUT api/commands/{id}
        [HttpPut("{id}")]
        public ActionResult UpdateCommand(int id, [FromBody]CommandUpdateDto commandUpdateDto)
        {
            var commandModelFromRepo = _repository.GetCommandById(id);
            if (commandModelFromRepo == null)
            {
                return NotFound();
            }

            _mapper.Map(commandUpdateDto, commandModelFromRepo);
            _repository.UpdateCommand(commandModelFromRepo);
            _repository.SaveChanges();
            return NoContent();
        }

        //PATCH api/commands/{id}
        [HttpPatch("{id}")]
        public ActionResult PartialCommandUpdate(int id, JsonPatchDocument<CommandUpdateDto> patchDoc)
        {
            var commandModelFromRepo = _repository.GetCommandById(id);
            if (commandModelFromRepo == null)
            {
                return NotFound();
            }

            
            var commandToPatch = _mapper.Map<CommandUpdateDto>(commandModelFromRepo);
            // ModelState este raspunzator de validitatea 
            patchDoc.ApplyTo(commandToPatch, ModelState);
            if (!TryValidateModel(commandToPatch))
            {
                return ValidationProblem(ModelState);
            }

            _mapper.Map(commandToPatch, commandModelFromRepo);
            _repository.UpdateCommand(commandModelFromRepo);
            _repository.SaveChanges();
            return NoContent();


        }
        

    }
}
