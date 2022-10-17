import React, { useEffect, useState } from "react";
import { Box, Button, Text } from "@chakra-ui/react";
import AnimalCard from "./animalCard";
import { mintAnimalTokenContract, web3 } from "../contracts";

interface SaleAnimalCardProps {
  account: string;
  animalType: string;
  animalPrice: string;
  animalTokenId: string;
}

const SaleAnimalCard = ({
  account,
  animalType,
  animalPrice,
  animalTokenId,
}: SaleAnimalCardProps) => {
  const [isBuyable, setIsBuyable] = useState<boolean>(false);
  const getAnimalTokenOwner = async () => {
    try {
      const response = await mintAnimalTokenContract.methods
        .ownerOf(animalTokenId)
        .call();

      setIsBuyable(
        response.toLocaleLowerCase() === account.toLocaleLowerCase()
      );
    } catch (e) {
      console.log(e);
    }
  };

  useEffect(() => {
    getAnimalTokenOwner();
  });

  return (
    <Box textAlign="center" w={150}>
      <AnimalCard animalType={animalType} />
      <Box>
        <Text d="inline-block">{web3.utils.fromWei(animalPrice)} ether</Text>
        <Button size="sm" colorScheme="green" m={2} disabled={isBuyable}>
          Buy
        </Button>
      </Box>
    </Box>
  );
};

export default SaleAnimalCard;
