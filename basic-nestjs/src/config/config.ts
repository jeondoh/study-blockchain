import { readFileSync } from 'fs';
import * as yaml from 'js-yaml';
import { join } from 'path';

const YAML_CONFIG_LOCAL = 'default.yaml';
const YAML_CONFIG_DEV = 'development.yaml';
const YAML_CONFIG_PROD = 'production.yaml';

export default () => {
  let yamlFileName = YAML_CONFIG_LOCAL;
  switch (process.env.NODE_ENV) {
    case 'dev':
      yamlFileName = YAML_CONFIG_DEV;
      break;
    case 'prod':
      yamlFileName = YAML_CONFIG_PROD;
      break;
  }
  return yaml.load(
    readFileSync(join(__dirname, yamlFileName), 'utf8'),
  ) as Record<string, any>;
};
