import React from "react";
import { Image } from "@chakra-ui/react";

interface AnimalCardProps {
  animalType: string;
}

const AnimalCard = ({ animalType }: AnimalCardProps) => {
  return (
    <Image w={150} h={150} src={`images/${animalType}.png`} alt="AnimalCard" />
  );
};

export default AnimalCard;
