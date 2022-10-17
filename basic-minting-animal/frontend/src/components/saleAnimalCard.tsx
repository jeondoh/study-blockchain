import React from "react";
import { Box, Button, Text } from "@chakra-ui/react";
import AnimalCard from "./animalCard";
import { web3 } from "../contracts";

interface SaleAnimalCardProps {
  animalType: string;
  animalPrice: string;
}

const SaleAnimalCard = ({ animalType, animalPrice }: SaleAnimalCardProps) => {
  return (
    <Box textAlign="center" w={150}>
      <AnimalCard animalType={animalType} />
      <Box>
        <Text d="inline-block">{web3.utils.fromWei(animalPrice)} ether</Text>
        <Button size="sm" colorScheme="green" m={2}>
          Buy
        </Button>
      </Box>
    </Box>
  );
};

export default SaleAnimalCard;
