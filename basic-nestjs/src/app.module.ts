import { Module } from '@nestjs/common';
import { MoviesController } from './movies/movies.controller';
import { MoviesService } from './movies/movies.service';
import { ConfigModule } from '@nestjs/config';
import config from './config/config';
import { DatabaseModule } from './config/typeorm.module';

@Module({
  imports: [
    ConfigModule.forRoot({ load: [config], isGlobal: true }),
    DatabaseModule,
  ],
  controllers: [MoviesController],
  providers: [MoviesService],
})
export class AppModule {}
